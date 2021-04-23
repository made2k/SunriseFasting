//
//  DatePickerRangeFactory.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/23/21.
//

import Foundation

enum DatePickerRangeFactory {
  
  static func range(from minDate: Date?, maxDate: Date?)  -> ClosedRange<Date> {
    let minDate = minDate ?? Date().dateByAdding(-1000, .year).date
    let maxDate = maxDate ?? Date().dateByAdding(1000, .year).date
    return minDate...maxDate
  }
  
}
