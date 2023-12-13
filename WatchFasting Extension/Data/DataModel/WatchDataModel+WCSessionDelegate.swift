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
import WidgetKit

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
  
  // We received new user info
  func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
    do {
      let data = try JSONSerialization.data(withJSONObject: userInfo, options: [])
      decodeAppDataUpdate(data)
      
    } catch {
      logger.error("Unable to parse json: \(error.localizedDescription)")
    }
  }

  private func decodeAppDataUpdate(_ data: Data) {
    
    let rawData = data
    let originalState = self.interfaceState

    do {
      let decoder = JSONDecoder()
      let data = try decoder.decode(SharedWidgetDataType.self, from: data)
      self.interfaceState = .init(from: data)
      
      if originalState != interfaceState {
        logger.warning("New interface state was detected")
        UserDefaults(suiteName: "group.com.zachmcgaughey.Fasting")?.set(rawData, forKey: "watch-widget-data")
        
        if #available(watchOS 9.0, *) {
          logger.warning("Requesting reload of timelines")
          WidgetCenter.shared.reloadTimelines(ofKind: "FastingWatchWidget")
        } else {
          // Fallback on earlier versions
        }
      }


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
