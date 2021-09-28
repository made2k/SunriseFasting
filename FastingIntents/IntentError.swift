//
//  IntentError.swift
//  FastingIntents
//
//  Created by Zach McGaughey on 9/28/21.
//

import Foundation

enum IntentError: Error {
  case fastAlreadyActive
  case noActiveFast
  case dataCorruption
}

extension IntentError: LocalizedError {
  
  var errorDescription: String? {
    
    switch self {
    case .fastAlreadyActive:
      return "You already have an active fast."
      
    case .noActiveFast:
      return "You don't have any active fasts."
      
    case .dataCorruption:
      return "There is a problem with your data. Please reinstall the app."
    }
    
  }
  
}
