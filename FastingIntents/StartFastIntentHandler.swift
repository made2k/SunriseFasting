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
  
  func confirm(intent: StartFastIntent) async -> StartFastIntentResponse {
    StartFastIntentResponse(code: .ready, userActivity: nil)
  }

  func handle(intent: StartFastIntent) async -> StartFastIntentResponse {
    
    do {
      let currentFast = try SiriDataManager.shared.getCurrentFast()

      guard currentFast == nil else {
        return .failure(failureReason: IntentError.fastAlreadyActive.localizedDescription)
      }

      let fast = try SiriDataManager.shared.createNewFast()
      
      let endTime: Date = fast.startDate.unsafelyUnwrapped.addingTimeInterval(fast.targetInterval)
      let endTimeDescription: String = StringFormatter.colloquialDateTime(from: endTime, separator: "at", capitalized: false)
      
      return .success(endTimeDescription: endTimeDescription)

    } catch IntentError.fastAlreadyActive {
      return .failure(failureReason: IntentError.fastAlreadyActive.localizedDescription)
      
    } catch IntentError.dataCorruption {
      return .failure(failureReason: IntentError.dataCorruption.localizedDescription)
      
    } catch {
      return .failure(failureReason: "An unknown error occurred")
    }
    
  }
  
}

