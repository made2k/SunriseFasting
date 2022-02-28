//
//  AppModel.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/20/21.
//

import Combine
import FastStorage
import Logging
import OSLog
import SwiftUI

final class AppModel: ObservableObject {

  let logger = Logger.create()
  
  static let preview: AppModel = {
    let model = AppModel(preview: true)
    model.loadDataFromStore()
    return model
  }()
  
  // MARK: - Properties
  
  /// DataManager to help persist data
  let manager: DataManager
  let widgetProvider: WidgetDataProvider
  
  /// The currently active FastModel if it exists.
  @Published var currentFast: FastModel?

  /// Array of all completed Fasts (ie not active)
  @Published var completedFasts: [Fast] = []
  
  /// A View reference that will can be used to track a full screen context takeover
  /// For instance a date picker that presents over the current screen.
  @Published var appPresentation: AnyView?
  
  private var cancellables: Set<AnyCancellable> = .init()
  
  private let historyObserver: PersistentHistoryObserver
  
  // MARK: - Lifecycle
  
  init(preview: Bool = false) {
    
    if preview {
      self.manager = DataManager.preview
      self.historyObserver = PersistentHistoryObserver(
        target: .app,
        persistentContainer: manager.persistenceController.container,
        cleaningTargetCompare: [.app],
        userDefaults: StorageDefaults.sharedDefaults
      )
      self.widgetProvider = WidgetDataProvider(manager.persistenceController.container)
      
    } else {
      self.manager = DataManager.shared
      self.historyObserver = PersistentHistoryObserver(
        target: .app,
        persistentContainer: manager.persistenceController.container,
        cleaningTargetCompare: [.app, .siriExtension],
        userDefaults: StorageDefaults.sharedDefaults
      )
      self.widgetProvider = WidgetDataProvider(manager.persistenceController.container)

      setupSubscriptions()
    }

    logger.trace("AppModel initialized")
    
    historyObserver.startObserving()

  }
  
  /// Subscribe  to any publishers
  private func setupSubscriptions() {
    
    // When our FastingGoal changes, update any current Fast we may have
    StorageDefaults.sharedDefaults.publisher(for: .fastingGoal)
      .compactMap { $0 }
      .compactMap(FastingGoal.init)
      .removeDuplicates()
      .dropFirst() // Drop first since we don't care about the initial value, only changes
      .sink { [weak self] (newGoal: FastingGoal) in
        self?.logger.debug("New FastingGoal set from Defaults: \(newGoal.rawValue, privacy: .private)")
        self?.currentFast?.duration = newGoal.duration
      }
      .store(in: &cancellables)
    
    // TODO: Remove delay once updated
    // Ideally we'd update our models and our view to automatically track managed context changes
    // via things like @FetchRequest and FetchedResults and this would not be neccessary. But I've noticed
    // refreshing our data without delay can result in data that is not updated.
    historyObserver.remoteChangePublisher
      .delay(for: .milliseconds(500), scheduler: RunLoop.main, options: .none)
      .sink { [weak self] in
        self?.loadCurrentFast()
        self?.loadCompletedFasts()
      }
      .store(in: &cancellables)

  }

}
