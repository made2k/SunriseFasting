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

private enum CircularSmallBuilder {
  
  static func build(percent: Float) -> CLKComplicationTemplate {
    let imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "basicImage")!)
    return CLKComplicationTemplateCircularSmallRingImage(imageProvider: imageProvider, fillFraction: percent, ringStyle: .open)
  }
  
}

private enum GraphicCircularBuilder {
  
  static func build(dateRange: ClosedRange<Date>?) -> CLKComplicationTemplate {
    
    // We will have a gauge provider no matter if we have dates or not,but the
    // type will vary
    let provider: CLKGaugeProvider
    
    if let range = dateRange {
      
      provider = CLKTimeIntervalGaugeProvider(
        style: .fill,
        gaugeColors: [.orange],
        gaugeColorLocations: nil,
        start: range.lowerBound,
        end: range.upperBound
      )
      
    } else {
      provider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: .orange, fillFraction: 0)
    }
    
    let imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "basicImage")!)
    return CLKComplicationTemplateGraphicCircularClosedGaugeImage(gaugeProvider: provider, imageProvider: imageProvider)
  }
  
}

private enum ModularSmallBuilder {
  
  static func build(percent: Float) -> CLKComplicationTemplate {
    let imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "basicImage")!)
    return CLKComplicationTemplateModularSmallRingImage(imageProvider: imageProvider, fillFraction: percent, ringStyle: .open)
  }
  
}


private enum UtilitarianSmallBuilder {
  
  static func build(percent: Float) -> CLKComplicationTemplate {
    let imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "basicImage")!)
    return CLKComplicationTemplateUtilitarianSmallRingImage(imageProvider: imageProvider, fillFraction: percent, ringStyle: .open)
  }
  
}

private enum GraphicExtraLargeBuilder {
  
  static func build(dateRange: ClosedRange<Date>?, percent: Double) -> CLKComplicationTemplate {
    
    guard let range = dateRange else {
      return idleTemplate()
    }
    
    let provider: CLKGaugeProvider = CLKTimeIntervalGaugeProvider(
      style: .fill,
      gaugeColors: [.orange],
      gaugeColorLocations: nil,
      start: range.lowerBound,
      end: range.upperBound
    )
    
    // We cannot display more than 3 characters in the gauge so we cut out the % from 100
    var text: String = StringFormatter.percent(from: percent)
    
    if percent >= 1 {
      text = text.replacingOccurrences(of: "%", with: "")
    }

    let textProvider = CLKSimpleTextProvider(text: text)
    return CLKComplicationTemplateGraphicExtraLargeCircularOpenGaugeView(
      gaugeProvider: provider,
      centerTextProvider: textProvider,
      bottomLabel: EmptyView()
    )
    
  }
  
  private static func idleTemplate() -> CLKComplicationTemplate {
    CLKComplicationTemplateGraphicExtraLargeCircularView(Text("Not Fasting"))
  }
  
}

private enum GraphicCornerBuilder {
  
  static func build(dateRange: ClosedRange<Date>?) -> CLKComplicationTemplate {
    
    guard let range = dateRange else {
      return idleTemplate()
    }

    let provider: CLKGaugeProvider = CLKTimeIntervalGaugeProvider(
      style: .fill,
      gaugeColors: [.orange],
      gaugeColorLocations: nil,
      start: range.lowerBound,
      end: range.upperBound
    )

    return CLKComplicationTemplateGraphicCornerGaugeView(
      gaugeProvider: provider,
      leadingTextProvider: nil,
      trailingTextProvider: nil,
      label: Circle().foregroundColor(.orange)
    )
    
  }
  
  private static func idleTemplate() -> CLKComplicationTemplate {
    let provider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: .orange, fillFraction: 0)
    return CLKComplicationTemplateGraphicCornerGaugeView(gaugeProvider: provider, label: Circle().foregroundColor(.white))
  }
  
}
