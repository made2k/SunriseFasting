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
        .background(Color(UIColor.systemBackground))
    case .active(let value):
      ActiveWidgetView(date: entry.date, data: value)
        .background(Color(UIColor.systemBackground))
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
    .supportedFamilies([.systemSmall, .systemMedium])
  }
}

// MARK: - Preview

struct FastingWidget_Previews: PreviewProvider {
  static var previews: some View {
    
    Group {
      
      FastingWidgetEntryView(entry: WidgetEntry(date: Date(), relevance: nil, data: .idle(lastFastDate: nil)))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
      
      FastingWidgetEntryView(entry: WidgetEntry(date: Date(), relevance: nil, data: .idle(lastFastDate: Date())))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
      
      FastingWidgetEntryView(entry: WidgetEntry(date: Date(), relevance: nil, data: .active(fastInfo: SharedFastInfo(Date(), interval: 60*60))))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
      
    }
    
  }
}
