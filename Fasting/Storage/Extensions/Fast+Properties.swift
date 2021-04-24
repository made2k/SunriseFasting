//
//  Fast+Properties.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/24/21.
//

import Foundation

// Add additional helper properties on the Fast entity
extension Fast {

  /// The progress of a fast as a percent value from 0..(1+)
  var progress: Double {
    return currentInterval / targetInterval
  }

  /// The current interval duration of the fast. If the fast has no `endDate`
  /// the interval is calculated based on the current date.
  var currentInterval: TimeInterval {
    let endDate = self.endDate ?? Date()
    let interval = endDate.timeIntervalSince(startDate!)
    return interval
  }

}
