//
//  SceneDelegate.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/16/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    
    if let scene = scene as? UIWindowScene {
      
      let window: UIWindow = UIWindow(windowScene: scene)
      window.rootViewController = TimerContainerViewController()
      window.makeKeyAndVisible()
      
      self.window = window

    }

  }
  
}

