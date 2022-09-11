//
//  IntervalCountingView.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/21/21.
//

import Formatting
import SwiftUI

struct IntervalCountingView: View {
  
  @StateObject private var timer = TimerObservable(interval: 1)
  private let referenceDate: Date
  private let formatStyle: TimeInterval.FormatStyle
  
  init(referenceDate: Date, formatStyle: TimeInterval.FormatStyle) {
    self.referenceDate = referenceDate
    self.formatStyle = formatStyle
  }
  
  var body: some View {
    
    Text(
      timer.value.timeIntervalSince(referenceDate).formatted(formatStyle)
    )
    .autoConnect(timer)
    
  }
}

struct IntervalCountingView_Previews: PreviewProvider {
  
  private static let referenceDate: Date = Date().dateByAdding(-12, .hour).date
  
  static var previews: some View {
    IntervalCountingView(referenceDate: referenceDate, formatStyle: .shortDuration)
  }
}
