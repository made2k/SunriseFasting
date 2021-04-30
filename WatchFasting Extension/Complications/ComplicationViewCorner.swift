//
//  ComplicationViewCorner.swift
//  WatchFasting Extension
//
//  Created by Zach McGaughey on 4/30/21.
//

import ClockKit
import SharedDataWatch
import SwiftUI

struct ComplicationViewCorner: View {
  
  var date: Date
  var data: SharedWidgetDataType
  
  var body: some View {
    switch data {
    case .idle:
      idleView()
      
    case .active(let info):
      activeView(info)
      
    }
  }
  
  func idleView() -> some View {
    ZStack {
      ProgressView(value: 0.0)
        .progressViewStyle(CircularProgressViewStyle(tint: .orange))
      // TODO: App Icon here
      Circle()
        .foregroundColor(.blue)
        .padding()
    }
  }
  
  func activeView(_ info: SharedFastInfo) -> some View {
    let progress: Double = min(date.timeIntervalSince(info.startDate) / info.targetInterval, 1.0)
    let text: String = StringFormatter.percent(from: progress)
    return Text("ahhh")
    
//    let provider: CLKGaugeProvider = CLKTimeIntervalGaugeProvider(
//      style: .fill,
//      gaugeColors: [.red],
//      gaugeColorLocations: nil,
//      start: Date(),
//      end: Date().addingTimeInterval(60)
//    )
//
//    let textProvider: CLKTextProvider = CLKTimeIntervalTextProvider(start: Date(), end: Date().addingTimeInterval(60))
//
//    return CLKComplicationTemplateGraphicCornerGaugeView(
//      gaugeProvider: provider,
//      leadingTextProvider: textProvider,
//      trailingTextProvider: nil,
//      label: Circle().foregroundColor(.white)
//    )
//
//    return ZStack {
//      Circle()
//        .fill(Color.white)
//      Text(text)
//        .foregroundColor(Color.black)
//      Circle()
//        .stroke(Color.orange, lineWidth: 5)
//    }
    
//    return ProgressView(text, value: progress)
//      .progressViewStyle(CircularProgressViewStyle(tint: .orange))
  }
  
}

struct ComplicationViewCorner_Previews: PreviewProvider {
  
  static var previews: some View {
    
    Group {
      
      
      CLKComplicationTemplateGraphicCornerGaugeView(gaugeProvider: CLKTimeIntervalGaugeProvider(style: .fill, gaugeColors: [.red], gaugeColorLocations: nil, start: Date(), end: Date().addingTimeInterval(60)), label: Circle().foregroundColor(.white))
        .previewContext()

      
      CLKComplicationTemplateGraphicCornerGaugeView(gaugeProvider: CLKSimpleGaugeProvider(style: .fill, gaugeColor: .orange, fillFraction: 0.2), label: Circle().foregroundColor(.white))
        .previewContext()
      
      CLKComplicationTemplateGraphicCornerCircularView(
        ComplicationViewCorner(date: Date(), data: .active(fastInfo: .init(Date().addingTimeInterval(-33), interval: 60)))
      )
      .previewContext()
      
      CLKComplicationTemplateGraphicCornerCircularView(
        ComplicationViewCorner(date: Date(), data: .idle(lastFastDate: nil))
      )
      .previewContext()
      
      
    }
    
  }
}
