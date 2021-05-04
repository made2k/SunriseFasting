//
//  GraphicExtraLargeBuilder.swift
//  WatchFasting Extension
//
//  Created by Zach McGaughey on 4/30/21.
//

import ClockKit
import Foundation
import SwiftUI

enum GraphicExtraLargeBuilder {

  static func build(dateRange: ClosedRange<Date>?, percent: Double) -> CLKComplicationTemplate {

    guard let range = dateRange else {
      return idleTemplate()
    }

    let gaugeColor: UIColor

    if percent >= 1 {
      gaugeColor = UIColor(named: "Complete").unsafelyUnwrapped
    } else {
      gaugeColor = UIColor(named: "Incomplete").unsafelyUnwrapped
    }

    let provider: CLKGaugeProvider = CLKTimeIntervalGaugeProvider(
      style: .fill,
      gaugeColors: [gaugeColor],
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

struct GraphicExtraLargeBuilder_Previews: PreviewProvider {

  private static let previewRange: ClosedRange<Date> =
    Date().addingTimeInterval(-60)...Date().addingTimeInterval(60)

  static var previews: some View {
    Group {
      GraphicExtraLargeBuilder.build(dateRange: nil, percent: 0)
        .previewContext()

      GraphicExtraLargeBuilder.build(dateRange: previewRange, percent: 0.43)
        .previewContext()
    }
  }

}

