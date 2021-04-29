//
//  ActiveFastView.swift
//  WatchFasting Extension
//
//  Created by Zach McGaughey on 4/29/21.
//

import Combine
import SharedDataWatch
import SwiftUI

struct ActiveFastView: View {

  @EnvironmentObject var model: WatchDataModel
  let fastInfo: SharedFastInfo?

  let startDateText: String
  let endDateText: String

  @State var progress: Double// = 0.0
  @State var durationText: String// = "00:00:00"

  init(_ fastInfo: SharedFastInfo?) {
    self.fastInfo = fastInfo
    
    if let fastInfo = fastInfo {
      startDateText = Self.dateText(from: fastInfo.startDate)
      
      let targetEnd: Date = fastInfo.startDate.addingTimeInterval(fastInfo.targetInterval)
      endDateText = Self.dateText(from: targetEnd)
      
      let now: Date = Date()
      
      _progress = State<Double>(wrappedValue: now.timeIntervalSince(fastInfo.startDate) / fastInfo.targetInterval)
      _durationText = State<String>(wrappedValue: Self.countdown(from: now.timeIntervalSince(fastInfo.startDate)))
      
    } else {
      startDateText = "--"
      endDateText = "--"
      _progress = State<Double>(wrappedValue: 0.0)
      _durationText = State<String>(wrappedValue: "--:--:--")
    }
  }

  var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  var body: some View {

    VStack {
      Text(durationText)
        .lineLimit(1)
        .font(Font.monospacedDigit(.title)())
        .minimumScaleFactor(0.6)

      ProgressView(value: progress)

      Spacer(minLength: 12)

      HStack() {
        VStack {
          Text("Started")
            .font(.caption2)
          Text(startDateText)
        }

        Spacer()

        VStack {
          Text("Goal")
            .font(.caption2)
          Text(endDateText)
        }
      }
      Button("Stop Fast") {
        guard let fastInfo = fastInfo else { return }
        model.askToSaveData(fastInfo)
      }
      .disabled(fastInfo == nil)
      
    }
    .padding()
    .onReceive(timer) { (currentDate: Date) in
      guard let fastInfo = fastInfo else { return }
      let interval = currentDate.timeIntervalSince(fastInfo.startDate)
      durationText = Self.countdown(from: interval)
      progress = interval / fastInfo.targetInterval
    }

  }

  static func countdown(from interval: TimeInterval) -> String {

    // Since we don't care about values less that a complete second, convert to integer
    let integerInterval: Int = Int(abs(interval))

    let seconds = integerInterval % 60
    let minutes = (integerInterval / 60) % 60
    let hours = (integerInterval / 3600)

    return String(format: "%0.2d:%0.2d:%0.2d", hours , minutes, seconds)

  }

  static func dateText(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter.string(from: date)
  }

}

struct ActiveFastView_Previews: PreviewProvider {
    static var previews: some View {
      ActiveFastView(SharedFastInfo(Date(), interval: 60*60))
          .environmentObject(WatchDataModel())

    }
}
