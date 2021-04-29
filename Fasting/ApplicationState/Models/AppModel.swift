//
//  AppModel.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/20/21.
//

import Combine
import Foundation
import OSLog
import SharedData
import SwiftUI
import WatchConnectivity

final class AppModel: NSObject, ObservableObject {

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
  var watchProvider: WatchDataProvider?
  let watchSession = WCSession.default
  
  /// The currently active FastModel if it exists.
  @Published var currentFast: FastModel? {
    didSet {
      sendStateToWatch(nil)
    }
  }
  /// Array of all completed Fasts (ie not active)
  @Published var completedFasts: [Fast] = []
  
  /// A View reference that will can be used to track a full screen context takeover
  /// For instance a date picker that presents over the current screen.
  @Published var appPresentation: AnyView?
  
  private var fastingGoalCancellable: AnyCancellable?
  
  // MARK: - Lifecycle
  
  init(preview: Bool = false) {
    
    if preview {
      self.manager = DataManager.preview
      self.widgetProvider = WidgetDataProvider(manager.persistenceController.container)
      self.watchProvider = WatchDataProvider(manager.persistenceController.container)

      super.init()
      
    } else {
      self.manager = DataManager.shared
      self.widgetProvider = WidgetDataProvider(manager.persistenceController.container)
      self.watchProvider = WatchDataProvider(manager.persistenceController.container)

      super.init()

      setupSubscriptions()
      setupWatchConnection()
    }

    logger.trace("AppModel initialized")
    
  }
  
  /// Subscribe  to any publishers
  private func setupSubscriptions() {
    
    // When our FastingGoal changes, update any current Fast we may have
    fastingGoalCancellable = UserDefaults.standard.publisher(for: .fastingGoal)
      .compactMap { $0 }
      .compactMap(FastingGoal.init)
      .removeDuplicates()
      .dropFirst() // Drop first since we don't care about the initial value, only changes
      .sink { [weak self] (newGoal: FastingGoal) in
        self?.logger.debug("New FastingGoal set from Defaults: \(newGoal.rawValue, privacy: .private)")
        self?.currentFast?.duration = newGoal.duration
      }

  }

  private func setupWatchConnection() {
    guard WCSession.isSupported() else {
      logger.info("WCSession not supported")
      return
    }

    watchSession.delegate = self
    watchSession.activate()
  }
  
}

extension AppModel: WCSessionDelegate {

  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    logger.debug("WCSession activation did complete, error? \(String(describing: error?.localizedDescription))")
  }

  func sessionDidBecomeInactive(_ session: WCSession) {
    logger.debug("WCSession did become inactive")
  }

  func sessionDidDeactivate(_ session: WCSession) {
    logger.debug("WCSession did deactivate")
  }

  func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
    let string = String(data: messageData, encoding: .utf8)
    if string == "load" {
      sendStateToWatch(replyHandler)
    } else if string == "start" {
      guard currentFast == nil else { return }
      var interval: TimeInterval = UserDefaults.standard.double(forKey: UserDefaultKey.fastingGoal.rawValue)
      if interval <= 0 {
        interval = FastingGoal.default.duration
      }
      startFast(interval: interval)
    } else if string == "stop" {
      guard let fast = currentFast else { return }
      endFast(fast, endDate: Date())
    }
  }

  private func sendStateToWatch(_ replyHandler: ((Data) -> Void)?) {
    let dataType: SharedWidgetDataType
    if let currentFast = currentFast {
      dataType = .active(fastInfo: SharedFastInfo(currentFast.startDate, interval: currentFast.duration))

    } else {
      dataType = .idle(lastFastDate: completedFasts.last?.endDate)
    }

    do {
      let encoder = JSONEncoder()
      let data = try encoder.encode(dataType)

      if let handler = replyHandler {
        handler(data)
      } else {
        watchSession.sendMessageData(data, replyHandler: nil) { error in
          self.logger.error("Error sending data to watch: \(error.localizedDescription)")
        }
      }

    } catch {
      logger.error("Error encoding data to send to watch")
    }

  }

}
