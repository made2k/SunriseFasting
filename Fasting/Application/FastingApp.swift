//
//  FastingApp.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/20/21.
//

import OSLog
import SwiftDate
import SwiftUI

@main
struct FastingApp: App {

  let logger = Logger.create(.application)
  private let model: AppModel = AppModel()
  private let watchManager: WatchManager
  
  init() {
    
    // Set up our default date region
    SwiftDate.defaultRegion = .local
    
    // Load initial data
    model.loadDataFromStore()
    
    // Start watch connectivity
    self.watchManager = WatchManager(model)
    
    // Setup default user values
    UserDefaults.standard.register(defaults: [UserDefaultKey.fastingGoal.rawValue: FastingGoal.default.rawValue])
    
    logger.trace("Application starting")
    
    // Clear any cached export values
    ExportManager.clearCache()
  }
  
  var body: some Scene {

    WindowGroup {
      
      HomeTabView()
        .environmentObject(model)

    }
  }
}
