//
//  WatchDataModel.swift
//  WatchFasting Extension
//
//  Created by Zach McGaughey on 4/28/21.
//

import Foundation
import SharedDataWatch
import WatchConnectivity
import os

enum WatchState: Equatable {
  case uninitialized
  case idlePending
  case idle
  case activePending
  case active(fastInfo: SharedFastInfo)
  case savingData(fastInfo: SharedFastInfo, endDate: Date)
  
  init(from data: SharedWidgetDataType) {
    
    switch data {
    
    case .idle:
      self = .idle
      
    case .active(let fastInfo):
      self = .active(fastInfo: fastInfo)
    }
    
  }
  
}

final class WatchDataModel: NSObject, ObservableObject {

  @Published var currentDataState: WatchState = .uninitialized
  @Published var currentFastData: SharedWidgetDataType?
  
  let session: WCSession = WCSession.default

  let logger: Logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Watch")
  
  private var isLocked: Bool = false

  override init() {
    super.init()
    session.delegate = self
    session.activate()
  }

  func loadFromPhone() {
    
    sendRequest("load") { [weak self] response in
      switch response {
      case .failure(let error):
        self?.logger.error("Error loading data: \(error.localizedDescription)")
        
      case .success:
        break
      }
    }

  }

  func requestToStart() {
    
    let startDate: Date = Date()
    let oldData: WatchState = currentDataState
    currentDataState = .activePending
    
    sendRequest("start", payload: ["date": startDate]) { [weak self] response in
      switch response {
      case .failure(let error):
        self?.logger.error("Error loading data: \(error.localizedDescription)")
        self?.currentDataState = oldData
        
      case .success:
        break
      }
    }
    
    currentFastData = .active(fastInfo: SharedFastInfo(startDate, interval: .infinity))
  }
  
  func askToSaveData(_ fastData: SharedFastInfo) {
    currentDataState = .savingData(fastInfo: fastData, endDate: Date())
  }

  func requestToStop(_ endDate: Date) {
    
    let oldData: WatchState = currentDataState
    currentDataState = .idlePending
    
    sendRequest("stop", payload: ["date": endDate]) { [weak self] response in
      switch response {
      case .failure(let error):
        self?.logger.error("Error loading data: \(error.localizedDescription)")
        self?.currentDataState = oldData
        
      case .success:
        break
      }
    }
    
    currentFastData = .idle(lastFastDate: nil)
  }
  
  func requestToDelete() {
    
    let oldData: WatchState = currentDataState
    currentDataState = .idlePending
    
    sendRequest("delete") { [weak self] response in
      switch response {
      case .failure(let error):
        self?.logger.error("Error deleting data: \(error.localizedDescription)")
        self?.currentDataState = oldData
        
      case .success:
        break
      }
    }
    
    currentFastData = .idle(lastFastDate: nil)
  }
  
  private func sendRequest(_ query: String, payload: [String: Any]? = nil, attempt: Int = 0, responseHandler: @escaping (Result<Void, Error>) -> Void) {
        
    var requestDictionary: [String: Any] = ["query": query]
    
    if let payload = payload {
      requestDictionary.merge(payload) { value, _ in
        return value
      }
    }
    
    let retryBlock: (() -> Void)?
    
    // Only attempt a retry 3 times before we give up.
    if attempt < 3 {
      retryBlock = { [weak self] in
        self?.sendRequest(query, payload: payload, attempt: attempt + 1, responseHandler: responseHandler)
      }
      
    } else {
      retryBlock = nil
    }
    
    session.sendMessage(requestDictionary, replyHandler: { [weak self] reply in
      DispatchQueue.main.async {
        self?.parseResponse(reply, handler: responseHandler)
      }
      
    }, errorHandler: { [weak self] error in
      DispatchQueue.main.async {
        self?.parseError(error, retry: retryBlock, handler: responseHandler)
      }
    })
    
  }
  
  private func parseResponse(_ response: [String: Any], handler: @escaping (Result<Void, Error>) -> Void) {
    
    if let error = response["error"] as? Error {
      handler(.failure(error))
      
    } else {
      handler(.success(()))
    }

  }
  
  private func parseError(_ error: Error, retry: (() -> Void)?, handler: @escaping (Result<Void, Error>) -> Void) {
    
    switch error {
    
    // If we get a notReachable error, try again after a short delay
    case WCError.notReachable:
      if let retry = retry {
        logger.warning("Received unreachable error, will retry")
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: retry)
        
      } else {
        logger.warning("Received unreachable error, without retry")
        fallthrough
      }
      
    default:
      logger.error("received error from query: \(error.localizedDescription)")
      handler(.failure(error))
    }
    
  }

}

extension WatchDataModel: WCSessionDelegate {

  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    logger.debug("WCSession activation completed. Error? \(String(describing: error?.localizedDescription))")
    loadFromPhone()
  }

  func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
    logger.debug("WCSession received message data")
    handleDecode(messageData)
  }

  func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
    handleDecode(messageData)
  }

  private func handleDecode(_ data: Data) {

    DispatchQueue.main.async {
      self.doDecode(data)
    }

  }

  private func doDecode(_ data: Data) {

    let decoder = JSONDecoder()

    do {
      let data = try decoder.decode(SharedWidgetDataType.self, from: data)
      self.currentDataState = .init(from: data)
      self.currentFastData = data

    } catch {
      self.logger.error("Unable to decode data")
    }

  }

}
