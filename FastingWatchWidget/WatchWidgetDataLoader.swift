//
//  WatchWidgetDataLoader.swift
//  FastingWidgetExtension
//
//  Created by Zach McGaughey on 4/26/21.
//

import Foundation
import os.log
import SharedDataWatch
import WidgetKit
import WatchConnectivity

class WatchWidgetDataLoader: NSObject {
  
  private let logger: Logger = .init(subsystem: "com.zachmcgaughey.Fasting", category: "Watch Widget")
  
  static let shared: WatchWidgetDataLoader = .init()
  
  private override init() {
    super.init()
  }
  
  func loadTimeline() -> [WatchWidgetEntry] {
    logger.warning("Loading timeline")
    let data = loadSharedData()
    
    switch data {
    case .active(let fastInfo):
      logger.warning("Loaded active fast with: \(fastInfo.startDate)")
      return getActiveTimeline(from: fastInfo)
      
    case .idle(let lastFast):
      logger.warning("Loaded idle fast")
      return getIdleTimeline(with: lastFast)

    }

  }
    
  func loadSharedData() -> SharedWidgetDataType {
    guard
      let data: Data = UserDefaults(suiteName: "group.com.zachmcgaughey.Fasting")?.data(forKey: "watch-widget-data"),
      let widgetData: SharedWidgetDataType = try? JSONDecoder().decode(SharedWidgetDataType.self, from: data)
    else {
      logger.warning("No data available, returning default state")
      return SharedWidgetDataType.idle(lastFastDate: nil)
    }

    return widgetData
  }
    
  private func getIdleTimeline(with lastFastDate: Date?) -> [WatchWidgetEntry] {
    [WatchWidgetEntry(date: Date(), data: .idle(lastFastDate: lastFastDate))]
  }
  
  private func getActiveTimeline(from fastInfo: SharedFastInfo) -> [WatchWidgetEntry] {
    
    var returnInfo: [WatchWidgetEntry] = []
    
    // Figure out how long each "percent" interval is
    let percentInterval: TimeInterval = fastInfo.targetInterval / 100
    
    // Calculate how many ticks we have until we hit 100%
    let currentPercent: Int = Int(Date().timeIntervalSince(fastInfo.startDate) / fastInfo.targetInterval * 100)
    
    // If over 100% we don't need further updates
    if currentPercent > 100 {
      return [WatchWidgetEntry(date: Date(), data: .active(fastInfo: fastInfo))]
    }
    
    /*
     We will update the widget every 1 percent to ensure smooth counter as well as ring.
     We determine the timeline by setting the times that each percent value will occur.
     End at 100% so that our widget stops updating when complete.
     */
    
    let requiredTicks: Int = Int(100 - currentPercent)
    let startPercent: Int = 100 - requiredTicks
    
    // Set our initial date based on the percent as opposed to now. Starting at the
    // percent start time will keep our timing in sync with the actual percent
    let widgetStart: Date = fastInfo.startDate.addingTimeInterval(Double(startPercent) * percentInterval)
    
    for tick in 0...requiredTicks {
      let targetDate: Date = widgetStart.addingTimeInterval(TimeInterval(tick) * percentInterval)
      let entry = WatchWidgetEntry(date: targetDate, data: .active(fastInfo: fastInfo))
      returnInfo.append(entry)
    }
    
    return returnInfo
  }
  
}
