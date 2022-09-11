//
//  EndFastIntentHandler.swift
//  FastingIntents
//
//  Created by Zach McGaughey on 9/28/21.
//

import FastStorage
import Foundation
import Logging
import OSLog

class EndFastIntentHandler: NSObject, EndFastIntentHandling {
  
  private let logger = Logger.create(.siriIntent)
  
  func confirm(intent: EndFastIntent) async -> EndFastIntentResponse {
    EndFastIntentResponse(code: .ready, userActivity: nil)
  }
  
  func handle(intent: EndFastIntent) async -> EndFastIntentResponse {
    
    do {
      
      guard let currentFast = try SiriDataManager.shared.getCurrentFast() else {
        return .failure(failureReason: IntentError.noActiveFast.localizedDescription)
      }

      try SiriDataManager.shared.endExistingFast(currentFast)
      return EndFastIntentResponse(code: .success, userActivity: nil)

    } catch {
      return .failure(failureReason: "An unknown error occurred")
    }
    
  }
  
}


