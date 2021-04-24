//
//  TimelineItemView.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/23/21.
//

import SwiftUI

struct TimelineItemView: View {
  
  private let fast: Fast
  @StateObject private var progressUpdater: ConstantUpdater
  
  init(_ fast: Fast) {
    self.fast = fast
    self._progressUpdater = StateObject(wrappedValue: ConstantUpdater(fast.progress))
  }
  
  var body: some View {
    
    HStack(spacing: 24) {
      RingView(progressUpdater)
        .thickness(8)
        .startColor(fast.progress < 1 ? .ringIncompleteStart : .ringCompleteStart)
        .endColor(fast.progress < 1 ? .ringIncompleteEnd : .ringCompleteEnd)
        .backgroundColor(fast.progress < 1 ? Color.ringIncompleteStart.opacity(0.1) : Color.ringIncompleteEnd.opacity(0.1))
        .frame(width: 64, height: 64, alignment: .center)
      VStack(alignment: .leading) {
        Text(StringFormatter.shortDateFormatter.string(from: fast.startDate!))
          .foregroundColor(Color(.secondaryLabel))
        Text(StringFormatter.percent(from: fast.progress))
        Text("\(StringFormatter.roundedHours(from: fast.currentInterval, includeSuffix: false))/\(StringFormatter.roundedHours(from: fast.targetInterval, includeSuffix: true))")
      }
      
      Spacer()
    }
    .cornerRadius(8)
    .autoConnect(progressUpdater)
    
  }
}

struct TimelineItemView_Previews: PreviewProvider {
  static var previews: some View {
    TimelineItemView(Fast.preview)
  }
}

