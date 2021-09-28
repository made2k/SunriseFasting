//
//  IntentHandler.swift
//  FastingIntents
//
//  Created by Zach McGaughey on 9/27/21.
//

import FastStorage
import Intents

class IntentHandler: INExtension {
  
  override func handler(for intent: INIntent) -> Any {
    if intent is StartFastIntent {
      return StartFastIntentHandler()
    }
    
    return self
  }
  
}
