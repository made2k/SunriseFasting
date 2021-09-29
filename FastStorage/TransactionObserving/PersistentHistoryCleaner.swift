//
//  PersistentHistoryCleaner.swift
//  FastStorage
//
//  Created by Zach McGaughey on 9/28/21.
//
// Thanks to https://www.avanderlee.com/swift/persistent-history-tracking-core-data/
// for the following code

import CoreData
import Foundation
import Logging
import OSLog

struct PersistentHistoryCleaner {
  
  let context: NSManagedObjectContext
  let targets: [AppTarget]
  let userDefaults: UserDefaults

  private let logger = Logger.create(.coreData)
  
  /// Cleans up the persistent history by deleting the transactions that have been merged into each target.
  func clean() throws {
    guard let timestamp = userDefaults.lastCommonTransactionTimestamp(in: targets) else {
      logger.info("Cancelling deletions as there is no common transaction timestamp")
      return
    }
    
    let deleteHistoryRequest = NSPersistentHistoryChangeRequest.deleteHistory(before: timestamp)
    logger.debug("Deleting persistent history using common timestamp \(timestamp)")
    try context.execute(deleteHistoryRequest)
    
    targets.forEach { target in
      /// Reset the dates as we would otherwise end up in an infinite loop.
      userDefaults.updateLastHistoryTransactionTimestamp(for: target, to: nil)
    }
  }
}
