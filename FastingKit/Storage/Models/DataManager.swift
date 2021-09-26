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
public final class DataManager {

  private let logger = Logger.create(.coreData)

  /// Shared persisted DataManager
  public static let shared = DataManager()
  /// A preview DataManager that does not persist data to disk
  public static let preview = DataManager(preview: true)
  
  // MARK: - Properties
  
  public let persistenceController: PersistenceController
  public var context: NSManagedObjectContext {
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
  
  public func createNewFast(_ startDate: Date, endDate: Date?, interval: TimeInterval) -> Fast {
    let fast = Fast(context: context)
    fast.startDate = startDate
    fast.endDate = endDate
    fast.targetInterval = interval
    
    saveChanges()
    
    return fast
  }
  
  public func delete(_ fast: Fast) {
    context.delete(fast)
    saveChanges()
  }
  
  // MARK: - Change Commits
  
  public func saveChanges() {
    
    guard context.hasChanges else { return }
    
    do {
      try context.save()
      
    } catch {
      logger.error("error saving changes: \(error.localizedDescription)")
    }
    
  }
  
  // MARK: - Data Retrieval
  
  public func fetch<T>(_ request: NSFetchRequest<T>) throws -> [T] where T: NSFetchRequestResult {
    try context.fetch(request)
  }
  
}
