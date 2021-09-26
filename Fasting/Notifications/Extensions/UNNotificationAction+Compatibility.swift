//
//  UNNotificationAction+Compatibility.swift
//  Fasting
//
//  Created by Zach McGaughey on 9/26/21.
//

import Foundation
import UserNotifications

extension UNNotificationAction {
  
  static func create(identifier: String, title: String, options: UNNotificationActionOptions = [], iconName: String? = nil) -> UNNotificationAction {
    
    if #available(iOS 15.0, *) {
      
      if let iconName = iconName {
        let actionIcon: UNNotificationActionIcon = .init(systemImageName: iconName)
        return UNNotificationAction(identifier: identifier, title: title, options: options, icon: actionIcon)
      }
    
    }
    
    return UNNotificationAction(identifier: identifier, title: title, options: options)

  }
  
}
