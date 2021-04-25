//
//  DataManager.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/22/21.
//

import CoreData
import Foundation
import OSLog

/// Class to help manage data persistence.
final class DataManager {

  let logger = Logger.create(.coreData)

  /// Shared persisted DataManager
  static let shared = DataManager()
  /// A preview DataManager that does not persist data to disk
  static let preview = DataManager(preview: true)
  
  // MARK: - Properties
  
  let persistenceController: PersistenceController
  var context: NSManagedObjectContext {
    persistenceController.container.viewContext
  }
  
  // MARK: - Lifecycle

  private init(preview: Bool = false) {
    
    if preview {
      persistenceController = PersistenceController.preview
      
    } else {
      persistenceController = PersistenceController.shared
    }
    
  }
  
  // MARK: - Object Management
  
  func createNewFast(_ startDate: Date, endDate: Date?, interval: TimeInterval) -> Fast {
    let fast = Fast(context: context)
    fast.startDate = Date()
    fast.endDate = endDate
    fast.targetInterval = interval
    
    saveChanges()
    
    return fast
  }
  
  func delete(_ fast: Fast) {
    context.delete(fast)
    saveChanges()
  }
  
  // MARK: - Change Commits
  
  func saveChanges() {
    
    guard context.hasChanges else { return }
    
    do {
      try context.save()
      
    } catch {
      logger.error("error saving changes: \(error.localizedDescription)")
    }
    
  }
  
  // MARK: - Data Retrieval
  
  func fetch<T>(_ request: NSFetchRequest<T>) throws -> [T] where T: NSFetchRequestResult {
    try context.fetch(request)
  }
  
}
