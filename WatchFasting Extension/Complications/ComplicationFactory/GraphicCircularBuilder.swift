//
//  GraphicCircularBuilder.swift
//  WatchFasting Extension
//
//  Created by Zach McGaughey on 4/30/21.
//

import ClockKit
import Foundation
import SwiftUI

enum GraphicCircularBuilder {

  static func build(for date: Date, dateRange: ClosedRange<Date>?) -> CLKComplicationTemplate {

    // We will have a gauge provider no matter if we have dates or not,but the
    // type will vary
    let provider: CLKGaugeProvider

    if let range = dateRange {

      let gaugeColor: UIColor

      if range.upperBound <= date {
        gaugeColor = UIColor(named: "Complete").unsafelyUnwrapped
      } else {
        gaugeColor = UIColor(named: "Incomplete").unsafelyUnwrapped
      }

      provider = CLKTimeIntervalGaugeProvider(
        style: .fill,
        gaugeColors: [gaugeColor],
        gaugeColorLocations: nil,
        start: range.lowerBound,
        end: range.upperBound
      )

    } else {
      provider = CLKSimpleGaugeProvider(
        style: .fill,
        gaugeColor: UIColor(named: "Idle").unsafelyUnwrapped,
        fillFraction: 0
      )
    }

    let imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Circular")!)
    return CLKComplicationTemplateGraphicCircularClosedGaugeImage(gaugeProvider: provider, imageProvider: imageProvider)
  }

}

//struct GraphicCircularBuilder_Previews: PreviewProvider {
//
//  private static let previewRange: ClosedRange<Date> =
//    Date().addingTimeInterval(-60)...Date().addingTimeInterval(60)
//
//  static var previews: some View {
//    Group {
//      GraphicCircularBuilder.build(dateRange: nil)
//        .previewContext()
//
//      GraphicCircularBuilder.build(dateRange: previewRange)
//        .previewContext()
//    }
//  }
//
//}
