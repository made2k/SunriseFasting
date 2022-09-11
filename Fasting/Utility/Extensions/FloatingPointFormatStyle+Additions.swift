//
//  FloatingPointFormatStyle+Additions.swift
//  Fasting
//
//  Created by Zach McGaughey on 9/11/22.
//

import Foundation

extension FormatStyle where Self == FloatingPointFormatStyle<Double>.Percent {

  static var percentRounded: FloatingPointFormatStyle<Double>.Percent {
    .percent.rounded(rule: .toNearestOrAwayFromZero, increment: 1)
  }
  
}
