//
//  PersistenceController.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/20/21.
//

import CoreData
import Logging
import SwiftDate
import OSLog

public struct PersistenceController {

  private static let logger = Logger.create(.coreData)

  // MARK: - Static Accessors
  
  /// The shared controller that will persist data to disk.
  public static let shared = PersistenceController()
  
  /// In memory store that does not write any data to disk
  public static var preview: PersistenceController = {
    let result = PersistenceController(inMemory: true)

    // Backfill history data
    for value in 2..<34 {
      let entity = Fast(context: result.container.viewContext)
      entity.startDate = Date().dateByAdding(-1 * value, .day).date
      entity.endDate = entity.startDate?.dateByAdding(Int.random(in: 3...18), .hour).date
      entity.targetInterval = 16.hours.timeInterval
    }
    
    do {
      try result.container.viewContext.save()
      
    } catch {
      logger.error("Error creating preview data: \(error.localizedDescription)")
    }
    
    /*
     Here we can hook in to result.container.viewContext to create
     and store any entities we'd like to preview with. Without these
     we just maintain an empty in memory store.
     */
    
    return result
    
  }()
  
  // MARK: - Properties
  
  public let container: NSPersistentContainer
  
  // MARK: - Lifecycle

  private init(inMemory: Bool = false) {
    
    guard let objectModelUrl = Bundle(identifier: "com.zachmcgaughey.FastingKit")?.url(forResource: "Fasting", withExtension: "momd") else {
      fatalError()
    }

    guard let objectModel = NSManagedObjectModel(contentsOf: objectModelUrl) else {
      fatalError()
    }

    self.container = NSPersistentContainer(name: "Fasting", managedObjectModel: objectModel)
    
    if inMemory {
      Self.logger.trace("Created memory persistent container")
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    }
    
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        Self.logger.error("Failed to load persistent stores: \(error.localizedDescription)")
        // Replace this implementation with code to handle the error appropriately.
        // preconditionFailure() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        
        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        preconditionFailure("Unresolved error \(error), \(error.userInfo)")
      } else {
        Self.logger.debug("Persistent stores loaded: \(storeDescription)")
      }
    })
  }
}
