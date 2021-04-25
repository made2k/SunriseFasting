//
//  Comparable+Clamp.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/24/21.
//

import Foundation

extension Comparable {

  func clamped(to range: ClosedRange<Self>) -> Self {

    if self > range.upperBound {
      return range.upperBound

    } else if self < range.lowerBound {
      return range.lowerBound

    } else {
      return self
    }

  }

}
