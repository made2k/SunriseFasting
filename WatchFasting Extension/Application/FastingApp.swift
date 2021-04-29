//
//  FastingApp.swift
//  WatchFasting Extension
//
//  Created by Zach McGaughey on 4/28/21.
//

import SwiftUI

@main
struct FastingApp: App {
  
  private let model: WatchDataModel = WatchDataModel()
  
  @SceneBuilder var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
          .environmentObject(model)
      }
    }
  }
  
}
