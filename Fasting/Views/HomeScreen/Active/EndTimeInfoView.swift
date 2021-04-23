//
//  EndTimeInfoView.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/21/21.
//

import SwiftUI

struct EndTimeInfoView: View {
  
  var referenceDate: Date
  
  var body: some View {
    VStack {
      Text("Target End")
        .font(.callout)
        .fontWeight(.semibold)
      Text(StringFormatter.colloquialDateTime(from: referenceDate))
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
