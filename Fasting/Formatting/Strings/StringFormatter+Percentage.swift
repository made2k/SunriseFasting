//
//  StringFormatter+Percentage.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/22/21.
//

import Foundation

extension StringFormatter {
  
  /// Formats a double value into a percent.
  ///
  /// - Attention:
  /// The double value should be 0-1 in terms of percentage. It will be formatted
  /// into 0-100% as the string representation.
  /// - Parameter value: A Double value
  /// - Returns: The value converted to a percentage (eg "45%")
  static func percent(from value: Double) -> String {
    let number: NSNumber = NSNumber(value: value)
    return percentFormatter.string(from: number) ?? "??"
  }
  
}
