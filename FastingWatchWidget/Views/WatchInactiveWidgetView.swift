//
//  WatchInactiveWidgetView.swift
//  FastingWatchWidgetExtension
//
//  Created by Zach McGaughey on 12/13/23.
//

import Foundation
import SharedDataWatch
import SwiftUI
import WidgetKit

struct WatchInactiveWidgetView: View {

  @Environment(\.widgetFamily) var family
  
  let lastFastDate: Date?

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
      
    case .accessoryInline:
      accessoryInline()
        .containerBackground(for: .widget) { }
      
    @unknown default:
      accessoryCircular()
        .containerBackground(for: .widget) { }

    }

  }
  
  private func accessoryInline() -> some View {
    Text("Sunrise Fasting")
  }

  private func accessoryCircular() -> some View {
    Gauge(value: 0) {
      Image(systemName: "fork.knife")
    }
    .gaugeStyle(.accessoryCircularCapacity)
  }
  
  private func accessoryCorner() -> some View {
    Gauge(value: 0) {
      Image(systemName: "fork.knife")
    }
    .gaugeStyle(.accessoryCircularCapacity)
  }
  
  private func accessoryRectangular() -> some View {
    HStack(alignment: .center, spacing: 8) {
      Image(systemName: "fork.knife")
      VStack(alignment: .leading) {
        if let lastFastDate {
          Text("Last Fast")
            .lineLimit(1)
            .font(.headline)
          Text(lastFastDate, style: .relative)
            .font(.subheadline)
        } else {
          Text("No active fast")
            .font(.headline)
          Text("Tap to get started")
            .font(.subheadline)
        }
      }
    }
  }

}

struct WatchInactiveWidgetView_Previews: PreviewProvider {
  static var previews: some View {

    Group {
      WatchInactiveWidgetView(lastFastDate: nil)
        .previewContext(WidgetPreviewContext(family: .accessoryCorner))

      WatchInactiveWidgetView(lastFastDate: nil)
        .previewContext(WidgetPreviewContext(family: .accessoryCircular))

      WatchInactiveWidgetView(lastFastDate: Date().addingTimeInterval(-1 * 60 * 65))
        .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
      
      WatchInactiveWidgetView(lastFastDate: Date().addingTimeInterval(-1 * 60 * 65))
        .previewContext(WidgetPreviewContext(family: .accessoryInline))
    }

  }
}
