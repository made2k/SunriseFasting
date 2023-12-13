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

    case .accessoryRectangular:
      accessoryRectangular()

    case .accessoryCorner:
      accessoryCorner()

    default:
      unknown()
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
  }
  
  private func accessoryCorner() -> some View {
    Gauge(
      value: percent,
      in: 0...1
    ) {
      Image(systemName: "fork.knife")
    }
    .gaugeStyle(.accessoryCircularCapacity)
  }
  
  private func accessoryRectangular() -> some View {
    HStack {
      Gauge(
        value: percent,
        in: 0...1
      ) {
        Image(systemName: "fork.knife")
      }
      .gaugeStyle(.accessoryCircularCapacity)
      .layoutPriority(0)

      VStack(alignment: .leading) {
        Text("Current Fast")
          .lineLimit(1)
          .font(.headline)
        Text(percent.formatted(.percent.precision(.significantDigits(3))))
          .font(.subheadline)
      }
      .layoutPriority(1)
    }
  }

}

struct WatchActiveWidgetView_Previews: PreviewProvider {
  static var previews: some View {

    Group {
      WatchActiveWidgetView(date: Date(), data: SharedFastInfo(Date().addingTimeInterval(-24*60), interval: 60*60))
        .previewContext(WidgetPreviewContext(family: .accessoryCorner))

      WatchActiveWidgetView(date: Date(), data: SharedFastInfo(Date().addingTimeInterval(-64*60), interval: 60*60))
        .previewContext(WidgetPreviewContext(family: .accessoryCircular))


      WatchActiveWidgetView(date: Date(), data: SharedFastInfo(Date().addingTimeInterval(-24*60), interval: 60*60))
        .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }

  }
}
