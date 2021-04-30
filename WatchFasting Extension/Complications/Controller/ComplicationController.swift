//
//  ComplicationController.swift
//  WatchFasting Extension
//
//  Created by Zach McGaughey on 4/28/21.
//

import ClockKit
import SharedDataWatch
import SwiftUI

class ComplicationController: NSObject, CLKComplicationDataSource {
  
  let dataController = WatchDataModel.shared
  var dataType: SharedWidgetDataType?

  private func loadIfNeeded(_ handler: @escaping (SharedWidgetDataType) -> Void) {
    
    switch dataController.interfaceState {
    case .active(let info):
      self.dataType = .active(fastInfo: info)
      
    case .idle:
      self.dataType = .idle(lastFastDate: nil)
      
    default:
      break
    }
    
    if let value = dataType {
      handler(value)
      
    } else {
      dataController.dataReceiveHooks.append { [weak self] data in
        self?.dataType = data
        handler(data)
      }
      dataController.refreshDataFromApp()

    }
    
  }

  // MARK: - Complication Configuration

  func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
    let descriptors = [
      CLKComplicationDescriptor(identifier: "complication", displayName: "Fasting", supportedFamilies: [.circularSmall, .modularSmall, .utilitarianSmall, .graphicCorner, .graphicCircular, .graphicExtraLarge])
      // Multiple complication support can be added here with more descriptors
    ]

    // Call the handler with the currently supported complication descriptors
    handler(descriptors)
  }

  func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
    // Do any necessary work to support these newly shared complication descriptors
  }

  // MARK: - Timeline Configuration

  func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
    // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines

    loadIfNeeded { data in
      
      switch data {
      case .idle:
        handler(nil)
        
      case .active(let info):
        let completionDate = info.startDate.addingTimeInterval(info.targetInterval)
        handler(completionDate)
      }
      
    }
    
  }

  func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
    // Call the handler with your desired behavior when the device is locked
    handler(.hideOnLockScreen)
  }

  // MARK: - Timeline Population

  func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
    // Call the handler with the current timeline entry

    loadIfNeeded { data in
      
      // calculate date so we're at proper offset
      let now = Date()
      let date: Date
      
      switch data {
      case .idle:
        date = Date()
        
      case .active(let info):
        let intervalChunks = info.targetInterval / 100.0
        let currentProgress = min(now.timeIntervalSince(info.startDate) / info.targetInterval, 1.0)
        let currentTick = Int(100 * currentProgress)
        let tickDate = info.startDate.addingTimeInterval(Double(currentTick) * intervalChunks)
        date = tickDate
      }
      
      guard let template = ComplicationTemplateFactory.makeTemplate(for: date, with: data, complication: complication) else {
        return handler(nil)
      }
      
      // TODO: What's the date here?
      let entry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
      handler(entry)
      
    }
    
  }

  func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
    // Call the handler with the timeline entries after the given date

    loadIfNeeded { data in

      switch data {
      case .idle:
        if let template = ComplicationTemplateFactory.makeTemplate(for: date, with: data, complication: complication) {
          let entry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
          return handler([entry])
        }
        
      case .active(let info):
        
        let onlyOneFamilies: [CLKComplicationFamily] = [.graphicCorner, .graphicExtraLarge, .graphicCircular]
        
        if onlyOneFamilies.contains(complication.family), let template = ComplicationTemplateFactory.makeTemplate(for: date, with: data, complication: complication) {
          let entry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
          return handler([entry])
        }
        
        var current: Date = date
        var entries: [CLKComplicationTimelineEntry] = []
        while current < info.startDate.addingTimeInterval(info.targetInterval) && entries.count < limit {
          
          if let template = ComplicationTemplateFactory.makeTemplate(for: current, with: data, complication: complication) {
            let entry = CLKComplicationTimelineEntry(date: current, complicationTemplate: template)
            entries.append(entry)
          }
          
          let updateInterval = info.targetInterval / 100.0
          current = current.addingTimeInterval(updateInterval)
        }
        
        return handler(entries)
      }
      
    }
    
  }

  // MARK: - Sample Templates

  func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
    // This method will be called once per supported complication, and the results will be cached
    handler(nil)
  }
}
