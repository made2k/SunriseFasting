//
//  FastingGoalPickerItemView.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/21/21.
//

import SwiftUI

struct FastingGoalPickerItemView: View {
  
  private let goal: FastingGoal
  
  init(_ goal: FastingGoal) {
    self.goal = goal
  }
  
  var body: some View {
    
    HStack{
      VStack(alignment: .leading, spacing: 7.0) {
        Text(goal.caseTitle)
          .font(.headline)
          .fontWeight(.heavy)
        Text(goal.caseDescription)
          .font(.footnote)
      }
      .padding()
      
      Spacer()
      
    }
    .background(Color(UIColor.secondarySystemGroupedBackground))
    .cornerRadius(8)
    
  }
  
}

struct GoalPickerItemView_Previews: PreviewProvider {
  static var previews: some View {
    FastingGoalPickerItemView(.default)
  }
}
