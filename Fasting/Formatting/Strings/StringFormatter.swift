//
//  StringFormatter.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/21/21.
//

import Foundation
import SwiftDate

enum StringFormatter {
  
  /*
   We lazily instantiate the formatters here for use
   throughout the app to save on performance.
   Reference:
   https://thostark.medium.com/speed-up-your-dateformatter-63efec7b6723
   */
  
  static var monthGroupTitleFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("MMMM yyyy")
    return formatter
  }()
  
  static var timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
  }()
  
  static var shortDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
  }()
    
  static var percentFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.minimumIntegerDigits = 1
    formatter.maximumFractionDigits = 0

    return formatter
  }()
  
}
