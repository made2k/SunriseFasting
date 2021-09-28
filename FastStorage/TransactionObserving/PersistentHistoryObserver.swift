//
//  PersistentHistoryObserver.swift
//  FastStorage
//
//  Created by Zach McGaughey on 9/28/21.
//

import Combine
import CoreData
import Foundation

public final class PersistentHistoryObserver {
  
  private let target: AppTarget
  private let userDefaults: UserDefaults
  private let persistentContainer: NSPersistentContainer
  
  private let remoteChangeSubject = PassthroughSubject<Void, Never>()
  public var remoteChangePublisher: AnyPublisher<Void, Never> {
    remoteChangeSubject.eraseToAnyPublisher()
  }
  
  private var cancellables: Set<AnyCancellable> = .init()
  
  /// An operation queue for processing history transactions.
  private lazy var historyQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    return queue
  }()
  
  public init(target: AppTarget, persistentContainer: NSPersistentContainer, userDefaults: UserDefaults) {
    self.target = target
    self.userDefaults = userDefaults
    self.persistentContainer = persistentContainer
  }
  
  public func startObserving() {
    
    NotificationCenter.default.publisher(for: .NSPersistentStoreRemoteChange, object: persistentContainer.persistentStoreCoordinator)
      .sink { [weak self] in
        self?.processStoreRemoteChanges($0)
      }
      .store(in: &cancellables)
    
  }
  
  /// Process persistent history to merge changes from other coordinators.
  @objc private func processStoreRemoteChanges(_ notification: Notification) {
    historyQueue.addOperation { [weak self] in
      self?.processPersistentHistory()
    }
  }
  
  @objc private func processPersistentHistory() {
    let context = persistentContainer.newBackgroundContext()
    context.name = persistentContainer.viewContext.name
    context.transactionAuthor = persistentContainer.viewContext.transactionAuthor
    
    context.performAndWait {
      do {
        let merger = PersistentHistoryMerger(backgroundContext: context, viewContext: persistentContainer.viewContext, currentTarget: target, userDefaults: userDefaults)
        let hasChanges = try merger.merge()
                
        let cleaner = PersistentHistoryCleaner(context: context, targets: AppTarget.allCases, userDefaults: userDefaults)
        try cleaner.clean()
        
        if hasChanges {
          remoteChangeSubject.send(())
        }

      } catch {
        print("Persistent History Tracking failed with error \(error)")
      }
    }
  }
  
}
