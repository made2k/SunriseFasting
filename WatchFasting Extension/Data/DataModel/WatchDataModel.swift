//
//  WatchDataModel.swift
//  WatchFasting Extension
//
//  Created by Zach McGaughey on 4/28/21.
//

import Foundation
import SharedDataWatch
import WatchConnectivity
import os

final class WatchDataModel: NSObject, ObservableObject {
  
  static let shared: WatchDataModel = WatchDataModel(activateSession: true)
  
  static func preview(_ state: InterfaceState? = nil) -> WatchDataModel {
    let model = WatchDataModel(activateSession: false)
    model.interfaceState = state ?? .uninitialized
    return model
  }

  @Published var interfaceState: InterfaceState = .uninitialized
  var isPending: Bool {
    
    switch interfaceState {
    case .idlePending, .activePending:
      return true
      
    case .active, .idle, .uninitialized, .savingData:
      return false
    }
    
  }
  
  let session: WCSession = WCSession.default
  let logger: Logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "WatchApp")
  
  var dataReceiveHooks: [(SharedWidgetDataType) -> Void] = []
  var hasOutstandingRefresh: Bool = false

  private init(activateSession: Bool) {
    super.init()
    
    if activateSession {
      session.delegate = self
      session.activate()
    }
    
  }
  
  func askToSaveFastingData(_ fastData: SharedFastInfo) {
    interfaceState = .savingData(fastInfo: fastData, endDate: Date())
  }

}
