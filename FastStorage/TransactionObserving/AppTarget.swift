//
//  AppTarget.swift
//  FastStorage
//
//  Created by Zach McGaughey on 9/28/21.
//

import Foundation

public enum AppTarget: String, CaseIterable {
  case app
  case siriExtension
}

extension AppTarget: ContextNaming {
  
  var tranactionAuthor: String {
    switch self {
    case .app:
      return "main_app"
      
    case .siriExtension:
      return "siri_extension"
    }
  }
  
  var contextName: String? {
    return nil
  }
  
}




extension UserDefaults {
  
  func lastHistoryTransactionTimestamp(for target: AppTarget) -> Date? {
    let key = "lastHistoryTransactionTimeStamp-\(target.rawValue)"
    return object(forKey: key) as? Date
  }
  
  func updateLastHistoryTransactionTimestamp(for target: AppTarget, to newValue: Date?) {
    let key = "lastHistoryTransactionTimeStamp-\(target.rawValue)"
    set(newValue, forKey: key)
  }
  
  func lastCommonTransactionTimestamp(in targets: [AppTarget]) -> Date? {
    let timestamp = targets
      .map { lastHistoryTransactionTimestamp(for: $0) ?? .distantPast }
      .min() ?? .distantPast
    return timestamp > .distantPast ? timestamp : nil
  }
}
