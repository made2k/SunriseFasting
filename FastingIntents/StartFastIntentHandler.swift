//
//  StartFastIntentHandler.swift
//  FastingIntents
//
//  Created by Zach McGaughey on 9/27/21.
//

import FastStorage
import Formatting
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

      let fast = try SiriDataManager.shared.createNewFast()
      
      let endTime: Date = fast.startDate.unsafelyUnwrapped.addingTimeInterval(fast.targetInterval)
      let endTimeDescription: String = StringFormatter.colloquialDateTime(from: endTime, separator: "at", capitalized: false)
      
      completion(.success(endTimeDescription: endTimeDescription))

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

