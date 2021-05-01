//
//  WatchManager.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/29/21.
//

import Foundation
import OSLog
import WatchConnectivity

/// This class acts as the API receiver for our watchOS app.
final class WatchManager: NSObject {
  
  private let appModel: AppModel
  private let provider: WatchDataProvider
  private let session = WCSession.default
  
  private let logger = Logger.create(.watch)
  
  init(_ model: AppModel) {
    self.appModel = model
    self.provider = WatchDataProvider(model.manager.persistenceController.container)
    
    super.init()
    
    setupWatchConnection()
  }
  
  private func setupWatchConnection() {
    guard WCSession.isSupported() else {
      logger.info("WCSession not supported")
      return
    }

    session.delegate = self
    session.activate()
  }
  
}

// MARK: - Watch API

extension WatchManager {
  
  private func handleAPIRequest(_ query: String, payload: [String: Any]?, replyHandler: @escaping ([String: Any]) -> Void) {
    logger.info("Received API request from watch: \(query)")
    
    let requestError: WatchAPIError?
    
    switch query.lowercased() {
    
    case "start":
      requestError = startFast(payload)
      
    case "stop":
      requestError = stopFast(payload)
      
    case "load":
      loadData()
      requestError = nil
      
    case "delete":
      requestError = deleteFast()
    
    default:
      requestError = WatchAPIError.invalidRequest
      
    }
    
    if let error = requestError {
      replyHandler(generateErrorResponse(error: error))
      
    } else {
      replyHandler(generateSuccessResponse())
    }
    
  }
  
  private func startFast(_ payload: [String: Any]?) -> WatchAPIError? {
    
    guard appModel.currentFast == nil else {
      return .fastAlreadyActive
    }
    
    var startDate: Date = Date()
    var goal: FastingGoal = .default
    
    if
      let stringValue = UserDefaults.standard.string(forKey: UserDefaultKey.fastingGoal.rawValue),
      let savedGoal = FastingGoal(rawValue: stringValue) {
      goal = savedGoal
    }
    
    if let start = payload?["date"] as? Date {
      startDate = start
    }
    
    DispatchQueue.main.async {
      self.appModel.startFast(startDate, interval: goal.duration)
    }

    return nil
  }
  
  private func stopFast(_ payload: [String: Any]?) -> WatchAPIError? {
    
    guard let model = appModel.currentFast else {
      return .noActiveFast
    }
    
    var endDate: Date = Date()
    
    if let date = payload?["date"] as? Date {
      endDate = date
    }
    
    DispatchQueue.main.async {
      self.appModel.endFast(model, endDate: endDate)
    }
    
    return nil
  }
  
  private func deleteFast() -> WatchAPIError? {
    
    guard let model = appModel.currentFast else {
      return .noActiveFast
    }
    
    DispatchQueue.main.async {
      self.appModel.deleteFast(model)
    }
    
    return nil
  }
  
  private func loadData() {
    // Load data does not return a response, but instead will
    // trigger an async update that will be delivered via data and
    // not dictionary
    provider.forceDataUpdate()
  }
  
  private func generateErrorResponse(error: WatchAPIError) -> [String: Any] {
    return ["error": error]
  }
  
  private func generateSuccessResponse() -> [String: Any] {
    return [:]
  }
  
}


// MARK: - WCSessionDelegate

extension WatchManager: WCSessionDelegate {
  
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    if let error = error {
      logger.debug("WCSession failed to activate with error: \(error.localizedDescription)")

    } else {
      logger.debug("WCSession successfully activated")
    }
  }

  func sessionDidBecomeInactive(_ session: WCSession) {
    logger.debug("WCSession did become inactive")
  }

  func sessionDidDeactivate(_ session: WCSession) {
    logger.debug("WCSession did deactivate")
  }
  
  func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
    
    guard let query = message["query"] as? String else {
      return replyHandler(generateErrorResponse(error: .invalidRequest))
    }
    
    handleAPIRequest(query, payload: message, replyHandler: replyHandler)
  }

}
