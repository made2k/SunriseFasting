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
        Text("\(Self.roundedHours(from: fast.currentInterval))/\(Self.roundedHours(from: fast.targetInterval))h")
      }
      
      Spacer()
    }
    .cornerRadius(8)
    .autoConnect(progressUpdater)
    
  }

  /// Format a TimeInterval into a short hour description (ie 16h)
  /// - Parameter interval: The TimeInterval to use for formatting
  /// - Returns: A string formatted like 16h
  private static func roundedHours(from interval: TimeInterval) -> String {
    let hours: TimeInterval = interval / 3600

    let formatter = NumberFormatter()
    formatter.roundingMode = .halfUp
    formatter.maximumFractionDigits = 0

    return formatter.string(from: NSNumber(value: hours)) ?? "0"
  }

}

struct TimelineItemView_Previews: PreviewProvider {
  static var previews: some View {
    TimelineItemView(Fast.preview)
  }
}

