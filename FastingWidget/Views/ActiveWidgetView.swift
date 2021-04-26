//
//  ActiveWidgetView.swift
//  SharedData
//
//  Created by Zach McGaughey on 4/26/21.
//

import Foundation
import RingView
import SharedData
import SwiftUI
import WidgetKit

struct ActiveWidgetView: View {
  
  @Environment(\.widgetFamily) var family
  
  let date: Date
  let data: SharedFastInfo
  
  var percent: Double {
    return min(date.timeIntervalSince(data.startDate) / data.targetInterval, 1)
  }
  
  // MARK: - Views
  
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
        RingView(ConstantUpdater(percent))
          .applyProgressiveStyle(percent)
          .thickness(8)
          .frame(maxWidth: 60, maxHeight: 60)
      }
      Spacer(minLength: 16)
      progressView()
      Text(data.startDate, style: .timer)
        .font(.body)
    }
    .padding()
    
  }
  
  private func mediumWidget() -> some View {
    
    HStack {
      VStack(alignment: .leading) {
        Spacer()
        progressView()
        Text(data.startDate, style: .timer)
          .font(Font.monospacedDigit(.largeTitle)())
          .lineLimit(1)
          .minimumScaleFactor(0.6)
      }
      .layoutPriority(1)
      RingView(ConstantUpdater(percent))
        .applyProgressiveStyle(percent)
        .thickness(14)
        .frame(minWidth: 100, minHeight: 100)
      
    }
    .padding()
    
  }
  
  @ViewBuilder
  private func progressView() -> some View {
    
    if percent >= 1 {
      Text("Completed")
        .font(.headline)
      
    } else {
      HStack(alignment: .center, spacing: 4) {
        Text("Elapsed")
          .font(.headline)
        Text("(\(percentString()))")
          .font(.caption)
          .bold()
          .foregroundColor(Color(UIColor.secondaryLabel))
      }
    }
    
  }
  
  // MARK: - Formatting
  
  private func percentString() -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.roundingMode = .floor
    formatter.maximumFractionDigits = 0
    
    return formatter.string(from: NSNumber(value: percent)) ?? "??"
  }
  
}

struct ActiveWidgetView_Previews: PreviewProvider {
  static var previews: some View {
    
    Group {
      ActiveWidgetView(date: Date(), data: SharedFastInfo(Date().addingTimeInterval(-24*60), interval: 60*60))
        .previewContext(WidgetPreviewContext(family: .systemSmall))

      ActiveWidgetView(date: Date(), data: SharedFastInfo(Date().addingTimeInterval(-64*60), interval: 60*60))
        .previewContext(WidgetPreviewContext(family: .systemSmall))

      
      ActiveWidgetView(date: Date(), data: SharedFastInfo(Date().addingTimeInterval(-24*60), interval: 60*60))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
      
      ActiveWidgetView(date: Date(), data: SharedFastInfo(Date().addingTimeInterval(-64*60), interval: 60*60))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
      
    }
    
  }
}
