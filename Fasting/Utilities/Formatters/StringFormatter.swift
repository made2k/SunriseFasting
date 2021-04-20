//
//  StringFormatter.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/19/21.
//

import Foundation
import SwiftDate

enum StringFormatter {
  
  private static var percentFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.minimumIntegerDigits = 1
    formatter.maximumFractionDigits = 0
    
    return formatter
  }()
  
  static func interval(from interval: TimeInterval, absoluteValue: Bool = true) -> String {
    
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
  
  static func colloquialDateTime(from date: Date) -> String {
    
    let timeString: String = date.toFormat("h:mm a")
    
    if date.isToday {
      return timeString
    }
    
    let dayString: String
    
    if date.isTomorrow {
      dayString = "tomorrow"
      
    } else if date.isYesterday {
      dayString = "yesterday"
      
    } else if date.isInside(date: Date(), granularity: .weekOfYear) {
      dayString = date.toFormat("EEEE")
      
    } else if date.isInside(date: Date().dateByAdding(-1, .weekOfYear).date, granularity: .weekOfYear) {
      dayString = "last \(date.toFormat("EEEE"))"
      
    } else if date.isInside(date: Date().dateByAdding(1, .weekOfYear).date, granularity: .weekOfYear) {
      dayString = "next \(date.toFormat("EEEE"))"
      
    } else {
      dayString = date.toString(.date(.medium))
    }
    
    return "\(dayString) at \(timeString)"
    
  }
  
  static func percent(from value: Double) -> String {
    percentFormatter.string(from: NSNumber(value: value)) ?? "??"
  }
  
}
