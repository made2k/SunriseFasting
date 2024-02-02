//
//  StringFormatter+TimeIntervals.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/22/21.
//

import Foundation

public extension StringFormatter {
  
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
  
  static func partialWordCountdown(from interval: TimeInterval) -> String {
    formatCountdownElements(interval: Int(interval), full: false)
  }
  
  /// Format a TimeInterval as a countdown string in the form `00:00:00`
  /// - Parameters:
  ///   - interval: The TimeInterval to use for formatting
  /// - Returns: A string formatted like `1 hour, 2 minutes, 3 seconds`
  static func wordCountdown(from interval: TimeInterval) -> String {
    formatCountdownElements(interval: Int(interval), full: true)
  }
  
  private static func formatCountdownElements(interval: Int, full: Bool) -> String {
    
    let seconds = interval % 60
    let minutes = (interval / 60) % 60
    let hours = (interval / 3600) % 24
    let days = (interval / (3600 * 24)) % 365
    let years = (interval / (3600 * 24 * 365))
    
    let yearValue: String = full ?
    String(localized: "year", comment: "Countdown element year") :
    String(localized: "yr", comment: "Shortened countdown element year")
    let dayValue: String = String(localized: "day", comment: "Countdown element day")
    let hourValue: String = full ?
    String(localized: "hour", comment: "Countdown element hour") :
    String(localized: "hr", comment: "Shortened countdown element hr")
    let minuteValue: String = full ?
    String(localized: "minute", comment: "Countdown element minute") :
    String(localized: "min", comment: "Shortened countdown element minute")
    let secondValue: String = full ?
    String(localized: "second", comment: "Countdown element second") :
    String(localized: "sec", comment: "Shortened countdown element second")
    
    var elements: [String] = []
    
    if years > 0 {
      elements.append("\(years) \(yearValue)" + (years != 1 ? "s" : ""))
    }
    
    if days > 0 {
      elements.append("\(days) \(dayValue)" + (days != 1 ? "s" : ""))
    }
    
    if hours > 0 {
      elements.append("\(hours) \(hourValue)" + (hours != 1 ? "s" : ""))
    }
    
    if minutes > 0 && days == 0 {
      elements.append("\(minutes) \(minuteValue)" + (minutes != 1 ? "s" : ""))
    }
    
    if hours == 0 {
      elements.append("\(seconds) \(secondValue)" + (seconds != 1 ? "s" : ""))
    }
    
    return elements.joined(separator: " ")
    
  }
  
}
