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
  
  private let fastInfo: SharedFastInfo?
  
  private let startDateText: String
  private let endDateText: String
  
  @State private var progress: Double = 0.0
  @State private var progressColor: Color = .orange
  @State private var durationText: String = "--:--:--"

  init(_ fastInfo: SharedFastInfo?) {
    self.fastInfo = fastInfo

    if let info = fastInfo {
      startDateText = StringFormatter.dateText(from: info.startDate)
      endDateText = StringFormatter.dateText(from: info.targetEndDate)
      
    } else {
      startDateText = "--:--"
      endDateText = "--:--"
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
        .progressViewStyle(LinearProgressViewStyle(tint: progressColor))

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
        model.askToSaveFastingData(fastInfo)
      }
      .disabled(model.isPending)
    }
    .padding()
    .onReceive(timer) { (currentDate: Date) in
      updateView(with: fastInfo, date: currentDate)
    }

  }
  
  private func updateView(with fastingInfo: SharedFastInfo?, date: Date) {
    
    if let info = fastInfo {
      updateViewWithInfo(info, now: date)
      
    } else {
      updateViewWithPending()
    }
    
  }
  
  private func updateViewWithInfo(_ info: SharedFastInfo, now: Date) {

    let now: Date = Date()
    let currentInterval: TimeInterval = now.timeIntervalSince(info.startDate)
    
    progress = min(currentInterval / info.targetInterval, 1.0)
    progressColor = progress < 1 ? .orange : .green
    durationText = StringFormatter.countdown(from: currentInterval)
  }
  
  private func updateViewWithPending() {
    progress = 0.0
    progressColor = .gray
    durationText = "--:--:--"
  }

}

struct ActiveFastView_Previews: PreviewProvider {
  static var previews: some View {
    ActiveFastView(SharedFastInfo(Date(), interval: 60))
      .environmentObject(WatchDataModel.preview())
    
  }
}
