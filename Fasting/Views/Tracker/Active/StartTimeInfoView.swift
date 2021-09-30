//
//  StartTimeInfoView.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/21/21.
//

import Formatting
import SwiftUI

struct StartTimeInfoView: View {
  
  @EnvironmentObject var model: AppModel
  @Binding var startDate: Date
  
  var body: some View {
    
    VStack {
      Text("Fast Started")
        .font(.callout)
        .fontWeight(.semibold)
      Text(StringFormatter.colloquialDateTime(from: startDate))
        .font(.callout)
        .foregroundColor(Color(UIColor.secondaryLabel))
      Button("Edit Start") {
        withAnimation {
          model.appPresentation = AnyView(
            DatePickerSelectionView(
              date: $startDate,
              minDate: Date().dateByAdding(-7, .day).date,
              maxDate: Date(),
              presented: $model.appPresentation,
              animate: true
            )
          )
        }
      }
    }
    
  }
  
}

struct StartTimeInfoView_Previews: PreviewProvider {
  
  static var previews: some View {
    StartTimeInfoView(startDate: .constant(Date()))
  }
  
}
