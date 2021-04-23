//
//  FastingGoal.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/21/21.
//

import Foundation

enum FastingGoal {
  
  static var `default`: FastingGoal = .sixteen

  case fourteen
  case sixteen
  case nineteen
  case twentyThree
  case custom(duration: TimeInterval)
  
  // MARK: - Lifecycle
  
  /// Initialize a FastingGoal from a TimeInterval.
  ///
  /// The initialization will create a defined case if the provided TimeInterval
  /// matches that cases duration. Otherwise `.custom` will be used.
  ///
  /// - Attention:
  /// This is a lossy creation in that if an interval is provided that matches a defined
  /// type, this will be created with the defined type. A custom value will only be
  /// created if the TimeInterval does not match a defined type.
  ///
  /// - Parameter interval: The TimeInterval to create the FastingGoal with.
  init(from interval: TimeInterval) {
    
    for type in Self.selectableCases {
      if type.duration == interval {
        self = type
        return
      }
    }
    
    self = .custom(duration: interval)

  }
  
  // MARK: - Properties
  
  var duration: TimeInterval {
    
    switch self {
    
    case .fourteen:
      return 14.hours.timeInterval
      
    case .sixteen:
      return 16.hours.timeInterval
      
    case .nineteen:
      return 19.hours.timeInterval
      
    case .twentyThree:
      return 23.hours.timeInterval
      
    case .custom(let value):
      return value
      
    }
    
  }
  
}
