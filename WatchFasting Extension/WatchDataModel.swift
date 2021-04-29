//
//  WatchDataModel.swift
//  WatchFasting Extension
//
//  Created by Zach McGaughey on 4/28/21.
//

import Foundation
import WatchSharedData
import WatchConnectivity
import os

final class WatchDataModel: NSObject, ObservableObject {

  @Published var currentFastData: SharedWidgetDataType?
  let session: WCSession = WCSession.default

  let logger: Logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Watch")

  override init() {
    super.init()
    session.delegate = self
    session.activate()
  }

  func loadFromPhone() {
    let string = "load"
    let data = string.data(using: .utf8)!
    session.sendMessageData(data) { loadedData in
      self.handleDecode(loadedData)

    } errorHandler: { error in
      switch error {
      case WCError.notReachable:
        self.logger.debug("Unreachable error retrying soon: \(error.localizedDescription)")
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
          self.loadFromPhone()
        }
      default:
        self.logger.debug("Unknown error: \(error.localizedDescription)")
      }

    }

  }

  func requestToStart() {
    let string = "start"
    let data = string.data(using: .utf8)!
    session.sendMessageData(data) { loadedData in
      self.handleDecode(loadedData)

    } errorHandler: { error in
      switch error {
      case WCError.notReachable:
        self.logger.debug("Unreachable error retrying soon: \(error.localizedDescription)")
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
          self.requestToStart()
        }
      default:
        self.logger.debug("Unknown error: \(error.localizedDescription)")
      }

    }
  }

  func requestToStop() {
    let string = "stop"
    let data = string.data(using: .utf8)!
    session.sendMessageData(data) { loadedData in
      self.handleDecode(loadedData)

    } errorHandler: { error in
      switch error {
      case WCError.notReachable:
        self.logger.debug("Unreachable error retrying soon: \(error.localizedDescription)")
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
          self.requestToStop()
        }
      default:
        self.logger.debug("Unknown error: \(error.localizedDescription)")
      }

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
//
//  func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
//    logger.debug("Received message?")
//  }
//
//  func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
//    logger.debug("huh?")
//  }
//
//  func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
//    logger.debug("userinfo")
//  }

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
      self.currentFastData = data

    } catch {
      self.logger.error("Unable to decode data")
    }

  }

}
