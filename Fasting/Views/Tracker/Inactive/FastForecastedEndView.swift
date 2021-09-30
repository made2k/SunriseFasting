//
//  FastForecastedEndView.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/21/21.
//

import FastStorage
import Formatting
import SwiftUI

struct FastForecastedEndView: View {
  
  let fastingGoal: FastingGoal
  @State var now: Date = Date()
  private let timer = TimerObservable(interval: 1)
  
  var body: some View {
    
    VStack {
      Text("Starting your fast now will complete it:")
        .lineLimit(1)
        .minimumScaleFactor(0.7)
      Text(StringFormatter.colloquialDateTime(from: now.addingTimeInterval(fastingGoal.duration)))
        .foregroundColor(Color(UIColor.secondaryLabel))
        .onReceive(timer.$value) { (date: Date) in
          now = date
        }
    }
    .autoConnect(timer)
    
  }
  
}


struct FastForecastedEndView_Previews: PreviewProvider {
  static var previews: some View {
    FastForecastedEndView(fastingGoal: .default)
  }
}
