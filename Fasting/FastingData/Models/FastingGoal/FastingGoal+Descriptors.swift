//
//  FastingGoal+Descriptors.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/22/21.
//

import FastStorage
import Foundation

extension FastingGoal {
  
  private static var table: String { "FastingGoal" }
  
  /// The descriptive title of the FastingGoal case.
  var caseTitle: String {
    
    switch self {
    
    case .fourteen:
      return String(localized: "fourteen title", table: Self.table)
      
    case .sixteen:
      return String(localized: "sixteen title", table: Self.table)

    case .nineteen:
      return String(localized: "nineteen title", table: Self.table)

    case .twentyThree:
      return String(localized: "twenty three title", table: Self.table)

    case .custom(_):
      return String(localized: "custom title", table: Self.table)
    }
    
  }
  
  /// An informative description of the type of fast.
  var caseDescription: String {
    
    switch self {
    
    case .fourteen:
      return String(localized: "fourteen description", table: Self.table)

    case .sixteen:
      return String(localized: "sixteen description", table: Self.table)

    case .nineteen:
      return String(localized: "nineteen description", table: Self.table)

    case .twentyThree:
      return String(localized: "twenty three description", table: Self.table)

    case .custom(_):
      return String(localized: "custom description", table: Self.table)
    }
    
  }
  
}
