//
//  TimelineItemView.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/23/21.
//

import FastStorage
import Formatting
import RingView
import SwiftUI

struct TimelineItemView: View {

  private static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
  }()
  
  private let fast: Fast
  @StateObject private var progressUpdater: ConstantUpdater
  
  init(_ fast: Fast) {
    self.fast = fast
    self._progressUpdater = StateObject(wrappedValue: ConstantUpdater(fast.progress))
  }
  
  var body: some View {

    VStack {
      HStack(spacing: 24) {
        RingView(progressUpdater)
          .thickness(8)
          .applyProgressiveStyle(fast.progress)
          .frame(width: 64, height: 64, alignment: .center)
        VStack(alignment: .leading) {
          Text(StringFormatter.shortDateFormatter.string(from: fast.startDate!))
            .foregroundColor(Color(.secondaryLabel))
          Text(StringFormatter.percent(from: fast.progress))
          Text("\(Self.roundedHours(from: fast.currentInterval))/\(Self.roundedHours(from: fast.targetInterval))h")
        }

        Spacer()

      }

      HStack {

        Text("\(Self.string(from: fast.startDate)) - \(Self.string(from: fast.endDate))").lineLimit(1)

        Spacer()

        if fast.mood > 0 {
          Text("Mood: \(fast.mood)")
        }

        if fast.note != nil {
          Image(systemName: "note.text")
        }

      }
      .font(.caption)
      .foregroundColor(.secondary)
    }
    .cornerRadius(8)
    
  }

  /// Format a TimeInterval into a short hour description (ie 16h)
  /// - Parameter interval: The TimeInterval to use for formatting
  /// - Returns: A string formatted like 16h
  private static func roundedHours(from interval: TimeInterval) -> String {
    let hours: TimeInterval = interval / 3600

    let formatter = NumberFormatter()
    formatter.roundingMode = .halfUp
    formatter.maximumFractionDigits = 1

    return formatter.string(from: NSNumber(value: hours)) ?? "0"
  }

  private static func string(from date: Date?) -> String {
    guard let date = date else { return "??" }
    return dateFormatter.string(from: date)
  }

}

struct TimelineItemView_Previews: PreviewProvider {
  static var previews: some View {

    VStack {
      TimelineItemView(Fast.preview(mood: 5, note: "t"))
        .frame(maxHeight: 120)

      TimelineItemView(Fast.preview)
        .frame(maxHeight: 72)
    }

  }
}

