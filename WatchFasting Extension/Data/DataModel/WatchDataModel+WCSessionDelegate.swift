//
//  WatchDataModel+WCSessionDelegate.swift
//  WatchFasting Extension
//
//  Created by Zach McGaughey on 4/29/21.
//

import ClockKit
import Foundation
import SharedDataWatch
import WatchConnectivity

extension WatchDataModel: WCSessionDelegate {

  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    if let error = error {
      logger.debug("WCSession failed with error: \(error.localizedDescription)")
    } else {
      logger.debug("WCSession successfully activated")
      // Immediately refresh app data
      refreshDataFromApp()
    }

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

      // If our complication hooks are empty, this update happened outside
      // of a complication which means they're no longer valid. Force a
      // refresh of all complications.
      if complicationHooks.isEmpty {

        CLKComplicationServer.sharedInstance().activeComplications?.forEach {
          CLKComplicationServer.sharedInstance().reloadTimeline(for: $0)
        }

      } else {
        flushComplicationHooks(with: data)
      }

    } catch {
      logger.error("Unable to decode data \(error.localizedDescription)")
    }

  }
  
  private func flushComplicationHooks(with data: SharedWidgetDataType) {

    complicationHooks.forEach { hook in
      hook(data)
    }
    
    complicationHooks.removeAll()
  }

}
