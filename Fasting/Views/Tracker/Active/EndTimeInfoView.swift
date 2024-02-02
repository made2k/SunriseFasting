//
//  EndTimeInfoView.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/21/21.
//

import Formatting
import SwiftUI

struct EndTimeInfoView: View {
  
  private var dateText: String
  
  init(referenceDate: Date) {
    self.dateText = StringFormatter.colloquialDateTime(from: referenceDate)
  }
  
  var body: some View {
    VStack {
      Text(
        "Target End",
        comment: "Title showing the end date/time for the current fast"
      )
      .font(.callout)
      .fontWeight(.semibold)
      Text(dateText)
        .foregroundColor(Color(UIColor.secondaryLabel))
        .font(.callout)
        .lineLimit(1)
        .minimumScaleFactor(0.8)
    }
  }
  
}


struct EndTimeInfoView_Previews: PreviewProvider {
  
  static var previews: some View {
    EndTimeInfoView(referenceDate: Date())
  }
  
}
