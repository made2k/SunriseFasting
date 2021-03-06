//
//  UserDefaults+Publishing.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/22/21.
//

import Combine
import FastStorage
import Foundation

extension UserDefaults {
  
  /// Create a publisher that will publish all updated values (including original) stored in defaults for a given key.
  /// - Parameter key: Key to use for lookups in UserDefaults.
  /// - Returns: A Publisher publishing values stored in UserDefaults
  func publisher<T>(for key: UserDefaultKey) -> AnyPublisher<T?, Never> {
    
    return NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)
      .compactMap { [weak self] (notification: Notification) -> UserDefaults? in
        
        guard let object: UserDefaults = notification.object as? UserDefaults, object == self else {
          return nil
        }
        return object
      }
      .prepend(self)
      .map { (defaults: UserDefaults) -> T? in
        defaults.value(forKey: key.rawValue) as? T
      }
      .eraseToAnyPublisher()
    
  }
  
}
