//
//  EndTimeInfoView.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/21/21.
//

import SwiftUI

struct EndTimeInfoView: View {

  private var dateText: String

  init(referenceDate: Date) {
    self.dateText = StringFormatter.colloquialDateTime(from: referenceDate)
  }
  
  var body: some View {
    VStack {
      Text("Target End")
        .font(.callout)
        .fontWeight(.semibold)
      Text(dateText)
        .foregroundColor(Color(UIColor.secondaryLabel))
        .font(.callout)
    }
  }

}


struct EndTimeInfoView_Previews: PreviewProvider {
  
  static var previews: some View {
    EndTimeInfoView(referenceDate: Date())
  }
  
}
