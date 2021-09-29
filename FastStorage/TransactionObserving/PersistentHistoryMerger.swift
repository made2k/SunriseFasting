//
//  PersistentHistoryMerger.swift
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

struct PersistentHistoryMerger {

  let logger = Logger.create(.coreData)
  
  let backgroundContext: NSManagedObjectContext
  let viewContext: NSManagedObjectContext
  let currentTarget: AppTarget
  let userDefaults: UserDefaults
  
  func merge() throws -> Bool {
    let fromDate = userDefaults.lastHistoryTransactionTimestamp(for: currentTarget) ?? .distantPast
    let fetcher = PersistentHistoryFetcher(context: backgroundContext, fromDate: fromDate)
    let history = try fetcher.fetch()
    
    guard !history.isEmpty else {
      logger.debug("No history transactions found to merge for target \(currentTarget.rawValue)")
      return false
    }

    logger.debug("Merging \(history.count) persistent history transactions for target \(currentTarget.rawValue)")
    
    history.merge(into: backgroundContext)
    
    viewContext.perform {
      history.merge(into: self.viewContext)
    }
    
    guard let lastTimestamp = history.last?.timestamp else { return true }
    userDefaults.updateLastHistoryTransactionTimestamp(for: currentTarget, to: lastTimestamp)
    
    return true
  }
}

internal extension Collection where Element == NSPersistentHistoryTransaction {
  
  /// Merges the current collection of history transactions into the given managed object context.
  /// - Parameter context: The managed object context in which the history transactions should be merged.
  func merge(into context: NSManagedObjectContext) {
    forEach { transaction in
      guard let userInfo = transaction.objectIDNotification().userInfo else { return }
      NSManagedObjectContext.mergeChanges(fromRemoteContextSave: userInfo, into: [context])
    }
  }
}
