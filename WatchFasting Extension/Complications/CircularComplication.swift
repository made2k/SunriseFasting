//
//  CircularComplication.swift
//  WatchFasting Extension
//
//  Created by Zach McGaughey on 4/29/21.
//

import ClockKit
import SharedDataWatch
import SwiftUI

struct CircularComplication: View {
  
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
    
    return ProgressView(text, value: progress)
      .progressViewStyle(CircularProgressViewStyle(tint: .orange))
  }
  
}

struct TestComplication_Previews: PreviewProvider {
  
  static var previews: some View {
    
    Group {
      CLKComplicationTemplateGraphicCircularView(
        CircularComplication(date: Date(), data: .active(fastInfo: .init(Date().addingTimeInterval(-33), interval: 60)))
      )
      .previewContext()
      
      CLKComplicationTemplateGraphicCircularView(
        CircularComplication(date: Date(), data: .idle(lastFastDate: nil))
      )
      .previewContext()


    }
    
  }
  
}
