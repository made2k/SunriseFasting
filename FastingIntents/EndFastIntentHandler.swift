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
  
  func confirm(intent: EndFastIntent, completion: @escaping (EndFastIntentResponse) -> Void) {
    completion(EndFastIntentResponse(code: .ready, userActivity: nil))
  }
  
  func handle(intent: EndFastIntent, completion: @escaping (EndFastIntentResponse) -> Void) {
    
    do {
      
      guard let currentFast = try SiriDataManager.shared.getCurrentFast() else {
        completion(.failure(failureReason: IntentError.noActiveFast.localizedDescription))
        return
      }

      try SiriDataManager.shared.endExistingFast(currentFast)
      completion(EndFastIntentResponse(code: .success, userActivity: nil))

    } catch {
      completion(.failure(failureReason: "An unknown error occurred"))
      return
    }
    
  }
  
}


