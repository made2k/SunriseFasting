//
//  PersistentHistoryFetcher.swift
//  FastStorage
//
//  Created by Zach McGaughey on 9/28/21.
//
// Thanks to https://www.avanderlee.com/swift/persistent-history-tracking-core-data/
// for the following code

import CoreData
import Foundation

struct PersistentHistoryFetcher {
  
  enum Error: Swift.Error {
    /// In case that the fetched history transactions couldn't be converted into the expected type.
    case historyTransactionConvertionFailed
  }
  
  let context: NSManagedObjectContext
  let fromDate: Date
  
  func fetch() throws -> [NSPersistentHistoryTransaction] {
    let fetchRequest = createFetchRequest()
    
    guard let historyResult = try context.execute(fetchRequest) as? NSPersistentHistoryResult, let history = historyResult.result as? [NSPersistentHistoryTransaction] else {
      throw Error.historyTransactionConvertionFailed
    }

    return history
  }
  
  func createFetchRequest() -> NSPersistentHistoryChangeRequest {
    let historyFetchRequest = NSPersistentHistoryChangeRequest
      .fetchHistory(after: fromDate)
    
    if let fetchRequest = NSPersistentHistoryTransaction.fetchRequest {
      var predicates: [NSPredicate] = []
      
      if let transactionAuthor = context.transactionAuthor {
        /// Only look at transactions created by other targets.
        predicates.append(NSPredicate(format: "%K != %@", #keyPath(NSPersistentHistoryTransaction.author), transactionAuthor))
      }
      if let contextName = context.name {
        // Only look at transactions not from our current context.
        predicates.append(NSPredicate(format: "%K != %@", #keyPath(NSPersistentHistoryTransaction.contextName), contextName))
      }

      // Only find results authored by us (ie ignore migrations)
      predicates.append(NSPredicate(format: "%K != nil", #keyPath(NSPersistentHistoryTransaction.contextName)))
//      predicates.append(NSPredicate(format: "%K IN %@", #keyPath(NSPersistentHistoryTransaction.author), AppTarget.allCases.map(\.tranactionAuthor)))
      
      fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
      historyFetchRequest.fetchRequest = fetchRequest
    }
    
    return historyFetchRequest
  }
}
