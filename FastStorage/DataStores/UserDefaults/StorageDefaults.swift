//
//  StorageDefaults.swift
//  FastStorage
//
//  Created by Zach McGaughey on 9/28/21.
//

import Foundation

public enum StorageDefaults {
  
  public static let sharedDefaults: UserDefaults = {
    guard let defaults = UserDefaults(suiteName: "group.com.zachmcgaughey.Fasting.data") else {
      preconditionFailure("Unable to load shared defaults")
    }
    
    return defaults
  }()
  
}


