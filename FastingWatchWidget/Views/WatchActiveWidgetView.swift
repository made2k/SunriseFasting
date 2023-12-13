//
//  WatchActiveWidgetView.swift
//  FastingWatchWidgetExtension
//
//  Created by Zach McGaughey on 4/26/21.
//

import Foundation
import SharedDataWatch
import SwiftUI
import WidgetKit

struct WatchActiveWidgetView: View {

  @Environment(\.widgetFamily) var family

  let date: Date
  let data: SharedFastInfo

  var percent: Double {
    return min(date.timeIntervalSince(data.startDate) / data.targetInterval, 1)
  }

  // MARK: - Views

  var body: some View {

    switch family {

    case .accessoryCircular:
      accessoryCircular()
        .containerBackground(for: .widget) { }

    case .accessoryRectangular:
      accessoryRectangular()
        .containerBackground(for: .widget) { }

    case .accessoryCorner:
      accessoryCorner()
        .containerBackground(for: .widget) { }

    default:
      unknown()
        .containerBackground(for: .widget) { }
    }

  }
  
  private func unknown() -> some View {
    Text("Unknown")
  }

  private func accessoryCircular() -> some View {
    Gauge(
      value: percent,
      in: 0...1
    ) {
      Image(systemName: "fork.knife")
    }
    .gaugeStyle(.accessoryCircularCapacity)
    .tint(percent >= 1 ? Color.green : Color.orange)
  }
  
  private func accessoryCorner() -> some View {
    Text(percent.formatted(.percent.precision(.fractionLength(0))))
      .widgetCurvesContent()
      .widgetLabel {
        ProgressView(value: percent, total: 1)
          .tint(percent >= 1 ? Color.green : Color.orange)
          .widgetAccentable()
      }
  }
  
  private func accessoryRectangular() -> some View {
    HStack {
      Gauge(
        value: percent,
        in: 0...1
      ) {
        HStack(spacing: 8) {
          Image(systemName: "fork.knife")
          VStack(alignment: .leading) {
            Text("Current Fast")
              .lineLimit(1)
              .font(.headline)
            Text(percent.formatted(.percent.precision(.fractionLength(0))))
              .font(.subheadline)
          }

        }
      }
      .gaugeStyle(.accessoryLinearCapacity)
      .tint(percent >= 1 ? Color.green : Color.orange)
    }
  }

}

struct WatchActiveWidgetView_Previews: PreviewProvider {
  static var previews: some View {

    Group {
      WatchActiveWidgetView(date: Date(), data: SharedFastInfo(Date().addingTimeInterval(-40*60), interval: 60*60))
        .previewContext(WidgetPreviewContext(family: .accessoryCorner))

      WatchActiveWidgetView(date: Date(), data: SharedFastInfo(Date().addingTimeInterval(-24*60), interval: 60*60))
        .previewContext(WidgetPreviewContext(family: .accessoryCircular))

      WatchActiveWidgetView(date: Date(), data: SharedFastInfo(Date().addingTimeInterval(-24*60+3), interval: 60*60))
        .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }

  }
}
