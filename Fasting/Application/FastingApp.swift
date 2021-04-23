//
//  FastingApp.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/20/21.
//

import SwiftDate
import SwiftUI

@main
struct FastingApp: App {
    
  private let model: AppModel = AppModel()
  
  init() {
    SwiftDate.defaultRegion = .local
    model.loadDataFromStore()
  }
  
  var body: some Scene {

    WindowGroup {
      
      HomeScreenView()
        .environmentObject(model)
        .environment(\.managedObjectContext, model.manager.context)

    }
  }
}
