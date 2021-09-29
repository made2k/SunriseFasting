//
//  PersistentHistoryObserver.swift
//  FastStorage
//
//  Created by Zach McGaughey on 9/28/21.
//
// Thanks to https://www.avanderlee.com/swift/persistent-history-tracking-core-data/
// for the following code

import Combine
import CoreData
import Foundation
import Logging
import OSLog

public final class PersistentHistoryObserver {
  
  private let target: AppTarget
  private let userDefaults: UserDefaults
  private let persistentContainer: NSPersistentContainer
  
  private let remoteChangeSubject = PassthroughSubject<Void, Never>()
  public var remoteChangePublisher: AnyPublisher<Void, Never> {
    remoteChangeSubject.eraseToAnyPublisher()
  }

  private var logger: Logger = Logger.create(.coreData)
  
  private var observingCancellable: AnyCancellable?
  
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
    
    observingCancellable = NotificationCenter.default
      .publisher(
        for: .NSPersistentStoreRemoteChange,
           object: persistentContainer.persistentStoreCoordinator
      )
      .sink { [weak self] in
        self?.processStoreRemoteChanges($0)
      }

  }
  
  /// Process persistent history to merge changes from other coordinators.
  private func processStoreRemoteChanges(_ notification: Notification) {
    historyQueue.addOperation { [weak self] in
      self?.processPersistentHistory()
    }
  }
  
  private func processPersistentHistory() {
    let context = persistentContainer.newBackgroundContext()
    // Set the context name and author on the background context so we can filter.
    context.name = persistentContainer.viewContext.name
    context.transactionAuthor = persistentContainer.viewContext.transactionAuthor
    
    context.performAndWait {
      do {
        let merger = PersistentHistoryMerger(
          backgroundContext: context,
          viewContext: persistentContainer.viewContext,
          currentTarget: target,
          userDefaults: userDefaults
        )
        let hasChanges = try merger.merge()
                
        let cleaner = PersistentHistoryCleaner(
          context: context,
          targets: AppTarget.allCases,
          userDefaults: userDefaults
        )
        try cleaner.clean()
        
        if hasChanges {
          remoteChangeSubject.send(())
        }

      } catch {
        logger.error("Persistent History Tracking failed with error \(error)")
      }
    }
  }
  
}
