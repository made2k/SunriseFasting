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
  
  /// Helper function to fetch a localized string given a key.
  ///
  /// This function encapsulates the bundle and table so only the key is required to
  /// access the string.
  ///
  /// - Parameter key: Key to fetch for the string
  /// - Returns: The localized string associated with the key.
  private static func string(for key: String) -> String {
    Bundle.main.localizedString(forKey: key, value: nil, table: table)
  }
  
  /// The descriptive title of the FastingGoal case.
  var caseTitle: String {
    
    switch self {
    
    case .fourteen:
      return Self.string(for: "fourteen title")
      
    case .sixteen:
      return Self.string(for: "sixteen title")
      
    case .nineteen:
      return Self.string(for: "nineteen title")

    case .twentyThree:
      return Self.string(for: "twenty three title")
      
    case .custom(_):
      return Self.string(for: "custom title")
    }
    
  }
  
  /// An informative description of the type of fast.
  var caseDescription: String {
    
    switch self {
    
    case .fourteen:
      return Self.string(for: "fourteen description")
      
    case .sixteen:
      return Self.string(for: "sixteen description")
      
    case .nineteen:
      return Self.string(for: "nineteen description")

    case .twentyThree:
      return Self.string(for: "twenty three description")
      
    case .custom(_):
      return Self.string(for: "custom description")
    }
    
  }
  
}
