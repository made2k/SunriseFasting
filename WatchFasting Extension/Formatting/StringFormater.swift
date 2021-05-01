//
//  StringFormater.swift
//  WatchFasting Extension
//
//  Created by Zach McGaughey on 4/29/21.
//

import Foundation

// TODO: This class duplicates code from the core application.
// It seemed overkill to create a two new targets and share
// a string formatter across them just to not duplicate the two
// functions in this class.
enum StringFormatter {
  
  private static let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
  }()
  
  private static let percentFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.minimumIntegerDigits = 1
    formatter.maximumFractionDigits = 0
    formatter.roundingMode = .down
    return formatter
  }()

  
  static func countdown(from interval: TimeInterval) -> String {

    let integerInterval: Int = Int(abs(interval))

    let seconds = integerInterval % 60
    let minutes = (integerInterval / 60) % 60
    let hours = (integerInterval / 3600)

    return String(format: "%0.2d:%0.2d:%0.2d", hours , minutes, seconds)

  }

  static func dateText(from date: Date) -> String {
    return timeFormatter.string(from: date)
  }
  
  static func percent(from value: Double) -> String {
    let number: NSNumber = NSNumber(value: value)
    return percentFormatter.string(from: number) ?? "??"
  }

}
