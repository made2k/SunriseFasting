//
//  StartFastIntentHandler.swift
//  FastingIntents
//
//  Created by Zach McGaughey on 9/27/21.
//

import FastStorage
import Foundation

class StartFastIntentHandler: NSObject, StartFastIntentHandling {
  
  func confirm(intent: StartFastIntent, completion: @escaping (StartFastIntentResponse) -> Void) {
    completion(StartFastIntentResponse(code: .ready, userActivity: nil))
  }
  
  func handle(intent: StartFastIntent, completion: @escaping (StartFastIntentResponse) -> Void) {
    
    do {
      let currentFast = try DataManager.shared.getCurrentFast()

      guard currentFast == nil else {
        completion(.failure(failureReason: "You already have an active fast."))
        return
      }

      try DataManager.shared.createNewFast()
      completion(.success(endTimeDescription: "Describing end time"))

    } catch {
      print(error)
      completion(.failure(failureReason: "An unknown error occurred"))
      return
    }
    
  }
  
}

