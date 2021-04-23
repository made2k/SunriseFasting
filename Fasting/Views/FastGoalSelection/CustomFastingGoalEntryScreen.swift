//
//  CustomFastingGoalEntryScreen.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/22/21.
//

import SwiftUI

struct CustomFastingGoalEntryScreen: View {
  
  // Binding to our persisted data
  @Binding var fastGoal: FastingGoal
  // Presented view to dismiss
  @Binding var presented: AnyView?
  // Used to animate in
  @State private var scale: CGFloat
  
  // Store our temporary text value here
  @State private var hours: Int?
  
  init(
    fastingGoal: Binding<FastingGoal>,
    presented: Binding<AnyView?>,
    animate: Bool
  ) {
    self._fastGoal = fastingGoal
    self._presented = presented
    self._scale = State<CGFloat>(initialValue: animate ? 0.0 : 1.0)
  }
  
  var body: some View {
    
    ZStack {
      BlurView(style: .systemUltraThinMaterialDark)
        .ignoresSafeArea()
      VStack {
        VStack(alignment: .leading) {
          Text("Set your own custom fasting target here")
          NumberTextField<Int>(title: "Custom Duration (Hours)", value: $hours, isFirstResponder: true)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .onAppear {
              guard scale != 1 else { return }
              DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                withAnimation(.easeOut(duration: 0.3)) {
                  scale = 1
                }
              }
            }
        }
        .padding()
        HStack(spacing: 0) {
          Button(action: cancelAction) {
            Text("Cancel")
              .frame(maxWidth: .infinity, minHeight: 48)
          }
          Text("")
            .frame(minWidth: 1, minHeight: 48)
            .background(Color(UIColor.separator))
          Button(action: saveAction) {
            Text("Save")
              .frame(maxWidth: .infinity, minHeight: 48)
          }
        }
      }
      .background(Color(UIColor.systemBackground))
      .cornerRadius(12)
      .padding()
      .scaleEffect(scale)
      
    }
    
  }
  
  private func saveAction() {
    // If no value was set, or the value is 0, don't save a new goal.
    if let value = hours, value > 0 {
      fastGoal = FastingGoal(from: value.hours.timeInterval)
    }
    
    dismiss()
  }
  
  private func cancelAction() {
    dismiss()
  }
  
  private func dismiss() {
    withAnimation {
      presented = nil
    }
  }
  
}

struct CustomGoalEntryScreen_Previews: PreviewProvider {
  static var previews: some View {
    CustomFastingGoalEntryScreen(
      fastingGoal: .constant(.sixteen),
      presented: .constant(nil),
      animate: false
    )
  }
}
