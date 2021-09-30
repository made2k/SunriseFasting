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
  private let absoluteValue: Bool
  
  init(referenceDate: Date, absoluteValue: Bool = true) {
    self.referenceDate = referenceDate
    self.absoluteValue = absoluteValue
  }
  
  var body: some View {
    
    Text(
      StringFormatter.countdown(from: timer.value.timeIntervalSince(referenceDate), absoluteValue: absoluteValue)
    )
    .autoConnect(timer)
    
  }
}

struct IntervalCountingView_Previews: PreviewProvider {
  
  private static let referenceDate: Date = Date().dateByAdding(-12, .hour).date
  
  static var previews: some View {
    IntervalCountingView(referenceDate: referenceDate)
  }
}
