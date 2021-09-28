//
//  PersistentHistoryMerger.swift
//  FastStorage
//
//  Created by Zach McGaughey on 9/28/21.
//

import CoreData
import Foundation

struct PersistentHistoryMerger {
  
  let backgroundContext: NSManagedObjectContext
  let viewContext: NSManagedObjectContext
  let currentTarget: AppTarget
  let userDefaults: UserDefaults
  
  func merge() throws -> Bool {
    let fromDate = userDefaults.lastHistoryTransactionTimestamp(for: currentTarget) ?? .distantPast
    let fetcher = PersistentHistoryFetcher(context: backgroundContext, fromDate: fromDate)
    let history = try fetcher.fetch()
    
    guard !history.isEmpty else {
      print("No history transactions found to merge for target \(currentTarget)")
      return false
    }
    
    print("Merging \(history.count) persistent history transactions for target \(currentTarget)")
    
    history.merge(into: backgroundContext)
    
    viewContext.perform {
      history.merge(into: self.viewContext)
    }
    
    guard let lastTimestamp = history.last?.timestamp else { return true }
    userDefaults.updateLastHistoryTransactionTimestamp(for: currentTarget, to: lastTimestamp)
    
    return true
  }
}

extension Collection where Element == NSPersistentHistoryTransaction {
  
  /// Merges the current collection of history transactions into the given managed object context.
  /// - Parameter context: The managed object context in which the history transactions should be merged.
  func merge(into context: NSManagedObjectContext) {
    forEach { transaction in
      guard let userInfo = transaction.objectIDNotification().userInfo else { return }
      NSManagedObjectContext.mergeChanges(fromRemoteContextSave: userInfo, into: [context])
    }
  }
}
