//
//  GoalPickerItemView.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/20/21.
//

import SwiftUI

struct GoalPickerItemView: View {
  
  let goal: FastingGoal
  
  var body: some View {
    
    ZStack {
      
      Color(.systemBackground)
      
      HStack{
        
        VStack(alignment: .leading, spacing: 7.0) {
          Text(goal.title)
            .font(.headline)
            .fontWeight(.heavy)
          Text(goal.description)
            .font(.footnote)
        }
        .padding()
        
        Spacer()
        
      }
            
    }
    .cornerRadius(8)
    
  }
}

struct GoalPickerItemView_Previews: PreviewProvider {
  static var previews: some View {
    GoalPickerItemView(goal: .sixteen)
  }
}
