//
//  SaveFastView.swift
//  WatchFasting Extension
//
//  Created by Zach McGaughey on 4/29/21.
//

import SharedDataWatch
import SwiftUI

struct SaveFastView: View {

  @EnvironmentObject var model: WatchDataModel

  let intervalString: String
  let intervalColor: Color
  let startedString: String
  let stoppedString: String

  let fastInfo: SharedFastInfo
  let stopDate: Date

  init(_ fastInfo: SharedFastInfo, stopDate: Date) {
    let elapsedInterval: TimeInterval = stopDate.timeIntervalSince(fastInfo.startDate)

    intervalString = StringFormatter.countdown(from: elapsedInterval)
    intervalColor = elapsedInterval >= fastInfo.targetInterval ? .green : .orange
    startedString = StringFormatter.dateText(from: fastInfo.startDate)
    stoppedString = StringFormatter.dateText(from: stopDate)

    self.fastInfo = fastInfo
    self.stopDate = stopDate
  }

  var body: some View {

    ScrollView {
      VStack(spacing: 4) {
        Text(intervalString)
          .foregroundColor(intervalColor)
          .lineLimit(1)
          .font(Font.monospacedDigit(.title)())
          .minimumScaleFactor(0.6)
        HStack() {
          VStack {
            Text("Started")
              .font(.caption2)
            Text(startedString)
          }

          Spacer()

          VStack {
            Text("Stopped")
              .font(.caption2)
            Text(stoppedString)
          }
        }
        Button {
          model.sendRequestToEndFast(stopDate)

        } label: {
          Text("Save")
        }
        Button {
          model.interfaceState = .active(fastInfo: fastInfo)

        } label: {
          Text("Cancel")
        }
        Button {
          model.sendRequestToDeleteCurrentFast()

        } label: {
          Text("Delete")
        }
        .foregroundColor(.red)

      }
      .padding()
    }

  }

}

struct SaveFastView_Previews: PreviewProvider {
  static var previews: some View {
    SaveFastView(SharedFastInfo(Date(), interval: 60), stopDate: Date().addingTimeInterval(45))
  }
}
