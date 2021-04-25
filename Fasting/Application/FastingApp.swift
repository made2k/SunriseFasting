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
  
  init() {
    SwiftDate.defaultRegion = .local
    model.loadDataFromStore()
    logger.trace("Application starting")
  }
  
  var body: some Scene {

    WindowGroup {
      
      HomeTabView()
        .environmentObject(model)

    }
  }
}
