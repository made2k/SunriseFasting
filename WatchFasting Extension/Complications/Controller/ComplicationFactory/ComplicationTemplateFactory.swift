//
//  ComplicationTemplateFactory.swift
//  WatchFasting Extension
//
//  Created by Zach McGaughey on 4/30/21.
//

import ClockKit
import Foundation
import SharedDataWatch
import SwiftUI

enum ComplicationTemplateFactory {
    
  static func makeTemplate(for date: Date, with data: SharedWidgetDataType, complication: CLKComplication) -> CLKComplicationTemplate? {

    let percent: Float
    let dateRange: ClosedRange<Date>?
    
    switch data {
    case .idle:
      percent = 0
      dateRange = nil
      
    case .active(let info):
      let progressValue: Double = date.timeIntervalSince(info.startDate) / info.targetInterval
      percent = Float(min(progressValue, 1.0))
      dateRange = info.startDate...info.targetEndDate.addingTimeInterval(info.targetInterval)
    }
    
    switch complication.family {
    
    case .circularSmall:
      return CircularSmallBuilder.build(percent: percent)
      
    case .graphicCircular:
      return GraphicCircularBuilder.build(dateRange: dateRange)
      
    case .modularSmall:
      return ModularSmallBuilder.build(percent: percent)
      
    case .utilitarianSmall:
      return UtilitarianSmallBuilder.build(percent: percent)
      
    case .graphicExtraLarge:
      return GraphicExtraLargeBuilder.build(dateRange: dateRange, percent: Double(percent))
          
    case .graphicCorner:
      return GraphicCornerBuilder.build(dateRange: dateRange)
      
    default:
      return nil
    }
    
  }
  
}
