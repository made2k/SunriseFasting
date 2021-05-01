//
//  GraphicCornerBuilder.swift
//  WatchFasting Extension
//
//  Created by Zach McGaughey on 4/30/21.
//

import ClockKit
import Foundation
import SwiftUI

enum GraphicCornerBuilder {

  static func build(dateRange: ClosedRange<Date>?) -> CLKComplicationTemplate {

    guard let range = dateRange else {
      return idleTemplate()
    }

    let gaugeProvider: CLKGaugeProvider = CLKTimeIntervalGaugeProvider(
      style: .fill,
      gaugeColors: [.orange],
      gaugeColorLocations: nil,
      start: range.lowerBound,
      end: range.upperBound
    )

    let imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Corner")!)

    return CLKComplicationTemplateGraphicCornerGaugeImage(
      gaugeProvider: gaugeProvider,
      leadingTextProvider: nil,
      trailingTextProvider: nil,
      imageProvider: imageProvider
    )

  }

  private static func idleTemplate() -> CLKComplicationTemplate {
    let gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: .orange, fillFraction: 0)
    let imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Corner")!)

    return CLKComplicationTemplateGraphicCornerGaugeImage(gaugeProvider: gaugeProvider, imageProvider: imageProvider)
  }

}

struct GraphicCornerBuilder_Previews: PreviewProvider {

  private static let previewRange: ClosedRange<Date> =
    Date().addingTimeInterval(-60)...Date().addingTimeInterval(60)

  static var previews: some View {
    Group {
      GraphicCornerBuilder.build(dateRange: nil)
        .previewContext()

      GraphicCornerBuilder.build(dateRange: previewRange)
        .previewContext()
    }
  }

}
