//
//  FastingWatchWidget.swift
//  FastingWatchWidget
//
//  Created by Zach McGaughey on 12/12/23.
//

import os.log
import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> WatchWidgetEntry {
    WatchWidgetEntry(date: Date(), data: .idle(lastFastDate: nil))
  }
  
  func getSnapshot(in context: Context, completion: @escaping (WatchWidgetEntry) -> ()) {
    Logger(subsystem: "com.zachmcgaughey.Fasting", category: "Test").warning("Getting snapshot from provier")
    Logger(subsystem: "com.zachmcgaughey.Fasting", category: "Test").warning("Snapshot info: \(context.isPreview)")
    let data = WatchWidgetDataLoader.shared.loadSharedData()
    let entry = WatchWidgetEntry(date: Date(), data: data)
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    Logger(subsystem: "com.zachmcgaughey.Fasting", category: "Test").warning("Getting timeline from provider")
    let entries: [Entry] =  WatchWidgetDataLoader.shared.loadTimeline()
    let timeline = Timeline(entries: entries, policy: .never)
    completion(timeline)
  }
}

struct FastingWatchWidgetEntryView : View {
  var entry: Provider.Entry

  var body: some View {
    switch entry.data {
    case .idle:
      Text("IDLE TODO")

    case .active(let value):
      WatchActiveWidgetView(date: entry.date, data: value)
    }
  }
}

@main
struct FastingWatchWidget: Widget {
  let kind: String = "FastingWatchWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      if #available(watchOS 10.0, *) {
        FastingWatchWidgetEntryView(entry: entry)
          .containerBackground(.fill.tertiary, for: .widget)
      } else {
        FastingWatchWidgetEntryView(entry: entry)
          .padding()
          .background()
      }
    }
    .configurationDisplayName("Sunrise")
    .description("View your fasting progress")
  }
}

#Preview(as: .accessoryRectangular) {
  FastingWatchWidget()
} timeline: {
  WatchWidgetEntry(date: .now, data: .idle(lastFastDate: nil))
}
