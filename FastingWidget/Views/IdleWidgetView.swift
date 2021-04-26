//
//  IdleWidgetView.swift
//  FastingWidgetExtension
//
//  Created by Zach McGaughey on 4/26/21.
//

import RingView
import SharedData
import SwiftUI
import WidgetKit

struct IdleWidgetView: View {
  
  @Environment(\.widgetFamily) var family
  
  let lastFastDate: Date?
  
  var body: some View {
    
    switch family {
    
    case .systemSmall:
      smallWidget()
      
    default:
      mediumWidget()
      
    }
    
  }
  
  private func smallWidget() -> some View {
    
    VStack(alignment: .leading) {
      HStack {
        Spacer()
        RingView(ConstantUpdater(0.0))
          .showEmptyRing(true)
          .applyProgressiveStyle(0.0)
          .thickness(8)
          .frame(maxWidth: 60, maxHeight: 60)
      }
      Spacer(minLength: 16)
      if let lastStart = lastFastDate {
        Text("Last Fast")
          .font(.headline)
        Text(lastStart, style: .relative)
          .font(.body)
      } else {
        Text("Get Started!")
          .font(.title)
          .minimumScaleFactor(0.2)
      }
      
    }
    .padding()
    
  }
  
  private func mediumWidget() -> some View {
    
    HStack {
      VStack(alignment: .leading) {
        Spacer()
        if let lastFast = lastFastDate {
          Text("Time Since Last Fast")
            .font(.headline)
          Text(lastFast, style: .relative)
            .font(Font.monospacedDigit(.largeTitle)())
            .lineLimit(1)
            .minimumScaleFactor(0.2)
        } else {
          Text("Get Started")
            .font(.largeTitle)
            .minimumScaleFactor(0.5)
        }
      }
      .layoutPriority(1)
      RingView(ConstantUpdater(0.0))
        .showEmptyRing(true)
        .applyProgressiveStyle(0.0)
        .thickness(14)
        .frame(minWidth: 100, minHeight: 100)
    }
    .padding()
    
  }
  
}

struct IdleWidgetView_Previews: PreviewProvider {
  static var previews: some View {
    
    Group {
      IdleWidgetView(lastFastDate: nil)
        .previewContext(WidgetPreviewContext(family: .systemSmall))
      
      IdleWidgetView(lastFastDate: Date().addingTimeInterval(-45 * 60))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
      
      IdleWidgetView(lastFastDate: nil)
        .previewContext(WidgetPreviewContext(family: .systemMedium))
      
      IdleWidgetView(lastFastDate: Date().addingTimeInterval(-45 * 60))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
    
    
  }
}
