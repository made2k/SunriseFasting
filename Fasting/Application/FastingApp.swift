//
//  FastingApp.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/20/21.
//

import Logging
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
    
    // Register our notification handler with our app model
    NotificationHandler.shared.register(with: model)
    
    // Setup default user values
    UserDefaults.standard.register(defaults: [UserDefaultKey.fastingGoal.rawValue: FastingGoal.default.rawValue])
    
    logger.trace("Application starting")
  }

  var body: some Scene {

    WindowGroup {

      HomeTabView()
        .environmentObject(model)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
          NotificationManager.shared.clearDelivered()
        }
      
    }
  }
}
