//
//  InterfaceState.swift
//  WatchFasting Extension
//
//  Created by Zach McGaughey on 4/29/21.
//

import Foundation
import SharedDataWatch

/// An enum that represents the possible interface states the watch app can be in.
enum InterfaceState: Equatable {
  
  /// This is the default state when first launched. It indicates we have no data
  /// and do not know what state our companion app is in.
  case uninitialized
  
  /// This is a transition state, when we're going from an active fast / save state, to
  /// an idle state, but we have not received confirmation that our data has successfully
  /// transfered.
  case idlePending
  
  /// The state when no active fast is started.
  case idle
  
  /// Transition state when we've sent a request to start a fast, but have not received
  /// confirmation that our request has succeeded.
  case activePending
  
  /// The state when we have an active fast.
  case active(fastInfo: SharedFastInfo)
  
  /// The state when we are ending a fast, but confirming with the user.
  case savingData(fastInfo: SharedFastInfo, endDate: Date)
  
  init(from data: SharedWidgetDataType) {
    
    switch data {
    
    case .idle:
      self = .idle
      
    case .active(let fastInfo):
      self = .active(fastInfo: fastInfo)
    }
    
  }
  
}
