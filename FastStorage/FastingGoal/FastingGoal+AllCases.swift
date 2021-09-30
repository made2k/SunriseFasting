//
//  FastingGoal+AllCases.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/22/21.
//

import Foundation

public extension FastingGoal {
  
  /// Get all types of cases for this enum.
  ///
  /// - Note:
  /// The custom case type returned by this function should **not** be used
  /// since it will have a duration of 0. This is intended for showing that custom is an option
  static var selectableCases: [FastingGoal] {
    [
      .fourteen,
      .sixteen,
      .nineteen,
      .twentyThree,
      .custom(duration: 0)
    ]
  }
  
}
