//
//  EndTimeInfoView.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/21/21.
//

import SwiftUI

struct EndTimeInfoView: View {
  
  let referenceDate: Date
  @State private var dateText: String

  init(referenceDate: Date) {
    self.referenceDate = referenceDate
    self._dateText = State<String>(initialValue: Self.getDateText(for: referenceDate))
  }
  
  var body: some View {
    VStack {
      Text("Target End")
        .font(.callout)
        .fontWeight(.semibold)
      Text(dateText)
        .foregroundColor(Color(UIColor.secondaryLabel))
        .font(.callout)
        .onNotification(UIApplication.significantTimeChangeNotification) {
          // Since our reference state is constant, we need to
          // trigger an update when the day changes. Listen to the notification
          // and update our text when the clock strikes midnight.
          dateText = Self.getDateText(for: referenceDate)
        }
    }
  }

  private static func getDateText(for date: Date) -> String {
    StringFormatter.colloquialDateTime(from: date)
  }

}


struct EndTimeInfoView_Previews: PreviewProvider {
  
  static var previews: some View {
    EndTimeInfoView(referenceDate: Date())
  }
  
}
