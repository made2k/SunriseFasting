//
//  FastingGoalPickerView.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/21/21.
//

import SwiftUI

struct FastingGoalPickerView: View {
    
  @EnvironmentObject var appModel: AppModel
  @AppStorage(UserDefaultKey.fastingGoal.rawValue) var fastingGoal: FastingGoal = .default

  // This view is presented, bind to dismiss
  @Binding var isPresented: Bool

  var body: some View {
    NavigationView {
      ScrollView {
        VStack {
          ForEach(FastingGoal.selectableCases) { (fastingGoal: FastingGoal) in
            FastingGoalPickerItemView(fastingGoal)
              .padding([.leading, .trailing], 16)
              .onTapGesture {
                saveSelection(fastingGoal)
              }
          }
        }
        .padding(.top, 16)
        .padding(.bottom, 64)
      }
      .navigationBarTitle("Fasting Goal", displayMode: .automatic)
      .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
    
  }
  
  private func saveSelection(_ goal: FastingGoal) {
    
    switch goal {
    // If custom is selected, we need to get input from the user
    case .custom:
      isPresented = false
      appModel.appPresentation = AnyView(
        CustomFastingGoalEntryScreen(fastingGoal: $fastingGoal, presented: $appModel.appPresentation, animate: true)
      )
      
    default:
      fastingGoal = goal
      isPresented = false
    }
    
  }

}

struct GoalPickerView_Previews: PreviewProvider {
  static var previews: some View {
    FastingGoalPickerView(isPresented: .constant(true))
  }
}

