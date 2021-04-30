//
//  WatchDataModel+WCSessionDelegate.swift
//  WatchFasting Extension
//
//  Created by Zach McGaughey on 4/29/21.
//

import Foundation
import SharedDataWatch
import WatchConnectivity
import ClockKit

extension WatchDataModel: WCSessionDelegate {

  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    logger.debug("WCSession activation completed. Error? \(String(describing: error?.localizedDescription))")
    refreshDataFromApp()
  }

  /// Our app sends us data when the data is updated via the main application. We can consume that data
  /// and update our watch state.
  func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
    logger.debug("WCSession received new data from companion app.")
    hasOutstandingRefresh = false
    DispatchQueue.main.async {
      self.decodeAppDataUpdate(messageData)
    }
  }

  private func decodeAppDataUpdate(_ data: Data) {

    do {
      let decoder = JSONDecoder()
      let data = try decoder.decode(SharedWidgetDataType.self, from: data)
      self.interfaceState = .init(from: data)
      if dataReceiveHooks.isEmpty {
        // need to schedule update
        for complication in CLKComplicationServer.sharedInstance().activeComplications ?? [] {
          CLKComplicationServer.sharedInstance().reloadTimeline(for: complication)
        }
      }
      flushHandlers(with: data)

    } catch {
      logger.error("Unable to decode data \(error.localizedDescription)")
    }

  }
  
  private func flushHandlers(with data: SharedWidgetDataType) {
    dataReceiveHooks.forEach {
      $0(data)
    }
    
    dataReceiveHooks.removeAll()
  }

}
