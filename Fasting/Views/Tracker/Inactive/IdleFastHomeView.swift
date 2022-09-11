//
//  IdleFastHomeView.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/20/21.
//

import FastStorage
import SwiftUI

struct IdleFastHomeView: View {
  
  @Environment(\.accessibilityReduceMotion) var reduceMotion
  @EnvironmentObject var model: AppModel

  @AppStorage(UserDefaultKey.fastingGoal.rawValue, store: StorageDefaults.sharedDefaults)
  var fastingGoal: FastingGoal = .default
  @State private var showingGoalSelection: Bool = false
  var namespace: Namespace.ID
  
  var body: some View {
    
    ZStack {
      
      Color(UIColor.systemGroupedBackground).ignoresSafeArea()
      
      VStack {
        TextButtonGroup("Current Fasting Goal", buttonTitle: fastingGoal.caseTitle) {
          showingGoalSelection = true
        }
        .buttonStyle(PaddedButtonStyle())
        .sheet(isPresented: $showingGoalSelection) { FastingGoalPickerView(isPresented: $showingGoalSelection) }
        
        Spacer()
        
        if let lastFastDate = model.completedFasts.first?.endDate {
          VStack {
            Text("Time since last fast")
            IntervalCountingView(referenceDate: lastFastDate, formatStyle: .mediumDuration)
              .monospaced(font: .largeTitle)
          }
          .matchedGeometryEffect(id: "interval", in: namespace)
          
        } else {
          Text("Get started with your first fast.")
            .font(.title)
            .multilineTextAlignment(.center)
        }
        
        Spacer()
        
        FastForecastedEndView(fastingGoal: fastingGoal)
        
        Spacer()
        
        Button("Start Fast") {
          withAnimation(reduceMotion ? .none : .default) {
            // _ = is needed or compiler crashes
            _ = model.startFast(interval: fastingGoal.duration)
          }
        }
        .buttonStyle(
          PaddedButtonStyle(
            foregroundColor: .buttonForegroundIncomplete,
            minWidth: 80
          )
        )
        .matchedGeometryEffect(id: "action", in: namespace)
        
        Spacer()
      }
      .padding()
    }
    
  }
  
}

struct IdleTimerScreen_Previews: PreviewProvider {
  
  @Namespace private static var namespace
  
  static var previews: some View {
    IdleFastHomeView(namespace: namespace)
      .environmentObject(AppModel.preview)
  }
}
