//
//  FastingWidget.swift
//  FastingWidget
//
//  Created by Zach McGaughey on 4/26/21.
//

import SharedData
import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {

  func placeholder(in context: Context) -> WidgetEntry {
    WidgetEntry(date: Date(), relevance: nil, data: .idle(lastFastDate: nil))
  }

  func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> ()) {
    let data = WidgetDataLoader.loadSharedData()
    let entry = WidgetEntry(date: Date(), relevance: nil, data: data)
    completion(entry)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    let entries = WidgetDataLoader.loadTimeline()
    let timeline = Timeline(entries: entries, policy: .never)
    completion(timeline)
  }

}

// MARK: - EntryView

struct FastingWidgetEntryView : View {
  var entry: Provider.Entry

  var body: some View {
    switch entry.data {
    case .idle(let value):
      IdleWidgetView(lastFastDate: value)
        .widgetBackground()

    case .active(let value):
      ActiveWidgetView(date: entry.date, data: value)
        .widgetBackground()

    }
  }
}

// MARK: - Widget

@main
struct FastingWidget: Widget {
  let kind: String = "FastingWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      FastingWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("Fasting Widget")
    .description("This displays information about your fasts.")
    .supportedFamilies(supportedFamilies)
  }

  private var supportedFamilies: [WidgetFamily] {
    if #available(iOSApplicationExtension 16.0, *) {
      [.systemSmall, .systemMedium, .accessoryCircular, .accessoryRectangular]

    } else {
      [.systemSmall, .systemMedium]
    }
  }
}

extension View {
  func widgetBackground() -> some View {
    if #available(iOSApplicationExtension 17.0, *) {
      return containerBackground(for: .widget) { }
    } else {
      return background { }
    }
  }
}

// MARK: - Preview

struct FastingWidget_Previews: PreviewProvider {
  static var previews: some View {

    Group {

      FastingWidgetEntryView(entry: WidgetEntry(date: Date(), relevance: nil, data: .idle(lastFastDate: nil)))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
        .previewDisplayName("Small Idle Empty")

      FastingWidgetEntryView(entry: WidgetEntry(date: Date(), relevance: nil, data: .idle(lastFastDate: Date())))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
        .previewDisplayName("Small Idle With Data")

      FastingWidgetEntryView(entry: WidgetEntry(date: Date(), relevance: nil, data: .active(fastInfo: SharedFastInfo(Date().addingTimeInterval(-5*60), interval: 60*60))))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
        .previewDisplayName("Small Active")

      FastingWidgetEntryView(entry: WidgetEntry(date: Date(), relevance: nil, data: .active(fastInfo: SharedFastInfo(Date().addingTimeInterval(-5*60), interval: 60*60))))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
        .previewDisplayName("Medium Active")

      if #available(iOSApplicationExtension 16.0, *) {
        FastingWidgetEntryView(entry: WidgetEntry(date: Date(), relevance: nil, data: .active(fastInfo: SharedFastInfo(Date().addingTimeInterval(-5*60), interval: 60*60))))
          .previewContext(WidgetPreviewContext(family: .accessoryCircular))
          .previewDisplayName("Accessory Circular Active")

        FastingWidgetEntryView(entry: WidgetEntry(date: Date(), relevance: nil, data: .idle(lastFastDate: nil)))
          .previewContext(WidgetPreviewContext(family: .accessoryCircular))
          .previewDisplayName("Accessory Circular Inactive")

        FastingWidgetEntryView(entry: WidgetEntry(date: Date(), relevance: nil, data: .active(fastInfo: SharedFastInfo(Date().addingTimeInterval(-5*60), interval: 60*60))))
          .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
          .previewDisplayName("Accessory Rectangular Active")

        FastingWidgetEntryView(entry: WidgetEntry(date: Date(), relevance: nil, data: .idle(lastFastDate: nil)))
          .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
          .previewDisplayName("Accessory Rectangular Inactive")
      }

    }

  }
}

