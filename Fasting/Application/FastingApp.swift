//
//  FastingApp.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/20/21.
//

import FastStorage
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
    
    migrateDefaultsIfNeeded()
    
    // Setup default user values
    StorageDefaults.sharedDefaults.register(defaults: [UserDefaultKey.fastingGoal.rawValue: FastingGoal.default.rawValue])
    
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
  
  private func migrateDefaultsIfNeeded() {
    
    let standard: UserDefaults = UserDefaults.standard
    let shared: UserDefaults = StorageDefaults.sharedDefaults
    
    if let appDefault = standard.string(forKey: UserDefaultKey.fastingGoal.rawValue) {
      shared.set(appDefault, forKey: UserDefaultKey.fastingGoal.rawValue)
      standard.removeObject(forKey: UserDefaultKey.fastingGoal.rawValue)
    }
    
  }

}
