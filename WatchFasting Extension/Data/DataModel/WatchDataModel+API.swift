//
//  WatchDataModel+API.swift
//  WatchFasting Extension
//
//  Created by Zach McGaughey on 4/29/21.
//

import Foundation
import SharedDataWatch
import WatchConnectivity

extension WatchDataModel {
  
  // MARK: - Companion App Requests
  
  func refreshDataFromApp() {
    guard hasOutstandingRefresh == false else {
      logger.info("Aborting app refresh, already waiting on data")
      return
    }
    
    sendRequest("load") { [weak self] response in
      switch response {
      case .failure(let error):
        self?.logger.error("Error loading data: \(error.localizedDescription)")
        
      case .success:
        break
      }
    }

  }

  func sendRequestToStartFast() {
    
    // Update our interface
    let fallbackInterfaceState = interfaceState
    interfaceState = .activePending
    
    let payload: [String: Any] = [
      "date": Date()
    ]
    
    sendRequest("start", payload: payload) { [weak self] response in
      switch response {
      case .failure(let error):
        self?.logger.error("Error starting fast: \(error.localizedDescription)")
        self?.interfaceState = fallbackInterfaceState
        
      case .success:
        self?.logger.debug("Start fast request succeeded")
      }
    }
    
  }
  
  func sendRequestToEndFast(_ endDate: Date) {
    
    let fallbackInterfaceState = interfaceState
    interfaceState = .activePending
    
    let payload: [String: Any] = [
      "date": endDate
    ]
    
    sendRequest("stop", payload: payload) { [weak self] response in
      switch response {
      case .failure(let error):
        self?.logger.error("Error ending fast: \(error.localizedDescription)")
        self?.interfaceState = fallbackInterfaceState
        
      case .success:
        self?.logger.debug("Stop fast request succeeded")
        break
      }
    }
    
  }
  
  func sendRequestToDeleteCurrentFast() {
    
    let fallbackInterfaceState = interfaceState
    interfaceState = .idlePending

    sendRequest("delete") { [weak self] response in
      switch response {
      case .failure(let error):
        self?.logger.error("Error deleting current fast: \(error.localizedDescription)")
        self?.interfaceState = fallbackInterfaceState
        
      case .success:
        self?.logger.debug("Delete fast request succeeded")
        break
      }
    }
    
  }
  
  // MARK: - Data Sender
  
  private func sendRequest(
    _ query: String,
    payload: [String: Any]? = nil,
    attempt: Int = 0,
    responseHandler: @escaping (Result<Void, Error>) -> Void
  ) {
        
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
  
  // MARK: - Response Parsing
  
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
