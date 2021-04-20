//
//  GoalPickerView.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/20/21.
//

import SwiftUI

struct GoalPickerView: View {
  
  let choices: [FastingGoal] = FastingGoal.all()
  
  var onGoalSelected: ((FastingGoal) -> Void)
  var onCustomSelected: () -> Void
    
  var body: some View {
    
    NavigationView {
      ScrollView {
        ZStack {
          LazyVStack {
            ForEach(choices, id: \.duration) { goal in
              GoalPickerItemView(goal: goal)
                .padding([.leading, .trailing], 16)
                .onTapGesture {
                  saveSelection(goal)
                }
            }
          }
          .padding(.top, 16)
          .padding(.bottom, 64)
        }
      }
      .navigationBarTitle("Fasting Goal", displayMode: .automatic)
      .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
    
  }
  
  private func saveSelection(_ goal: FastingGoal) {
    
    switch goal {
    
    case .custom:
      onCustomSelected()
      
    default:
      onGoalSelected(goal)
    }
    
  }

}

struct GoalPickerView_Previews: PreviewProvider {
  static var previews: some View {
    GoalPickerView(onGoalSelected: { _ in }, onCustomSelected: { })
  }
}
