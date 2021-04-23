//
//  HomeScreenView.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/21/21.
//

import SwiftUI

struct HomeScreenView: View {
  
  @EnvironmentObject private var model: AppModel
  @Namespace var namespace
  
  var body: some View {
    ZStack {
      // Based on having a current fast, we display a different screen
      switch model.currentFast {
      case .none:
        IdleFastHomeView(namespace: namespace)
          .ignoresSafeArea(.keyboard)
          .zIndex(1)
        
      case .some(let fast):
        ActiveFastHomeView(fast: fast, namespace: namespace)
          .ignoresSafeArea(.keyboard)
          .zIndex(1)
      }
      // Here is where we use our full app presentation if set
      if let presented = model.appPresentation {
        presented
          .zIndex(2)
      }
    }
  }
  
}

struct TimerContainerScreen_Previews: PreviewProvider {
  static var previews: some View {
    HomeScreenView()
      .environmentObject(AppModel.preview)
  }
}
