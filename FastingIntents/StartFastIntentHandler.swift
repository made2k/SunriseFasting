//
//  StartFastIntentHandler.swift
//  FastingIntents
//
//  Created by Zach McGaughey on 9/27/21.
//

import FastStorage
import Foundation
import Logging
import OSLog

class StartFastIntentHandler: NSObject, StartFastIntentHandling {
  
  private let logger = Logger.create(.siriIntent)
  
  func confirm(intent: StartFastIntent, completion: @escaping (StartFastIntentResponse) -> Void) {
    completion(StartFastIntentResponse(code: .ready, userActivity: nil))
  }
  
  func handle(intent: StartFastIntent, completion: @escaping (StartFastIntentResponse) -> Void) {
    
    do {
      let currentFast = try SiriDataManager.shared.getCurrentFast()

      guard currentFast == nil else {
        completion(.failure(failureReason: IntentError.fastAlreadyActive.localizedDescription))
        return
      }

      try SiriDataManager.shared.createNewFast()
      // TODO: Add localized time
      completion(.success(endTimeDescription: "Describing end time"))

    } catch IntentError.fastAlreadyActive {
      completion(.failure(failureReason: IntentError.fastAlreadyActive.localizedDescription))
      
    } catch IntentError.dataCorruption {
      completion(.failure(failureReason: IntentError.dataCorruption.localizedDescription))
      
    } catch {
      completion(.failure(failureReason: "An unknown error occurred"))
      return
    }
    
  }
  
}

