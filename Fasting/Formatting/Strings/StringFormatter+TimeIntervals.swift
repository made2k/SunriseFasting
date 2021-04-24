//
//  StringFormatter+TimeIntervals.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/22/21.
//

import Foundation

extension StringFormatter {
  
  /// Format a TimeInterval as a countdown string in the form `00:00:00`
  /// - Parameters:
  ///   - interval: The TimeInterval to use for formatting
  ///   - absoluteValue:
  ///   If true the formatted string will use the absolute value resulting in positive representation
  ///   of the string even if TimeInterval is negative.
  /// - Returns: A string formatted like `00:00:00`
  static func countdown(from interval: TimeInterval, absoluteValue: Bool = true) -> String {
    
    // Since we don't care about values less that a complete second, convert to integer
    let integerInterval: Int
    
    if absoluteValue {
      integerInterval = Int(abs(interval))
      
    } else {
      integerInterval = Int(interval)
    }
    
    let seconds = integerInterval % 60
    let minutes = (integerInterval / 60) % 60
    let hours = (integerInterval / 3600)
    
    return String(format: "%0.2d:%0.2d:%0.2d", hours , minutes, seconds)
    
  }
  
}
