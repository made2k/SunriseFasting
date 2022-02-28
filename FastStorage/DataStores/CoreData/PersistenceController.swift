//
//  PersistenceController.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/20/21.
//

import CoreData
import Logging
import OSLog

public struct PersistenceController {
  
  static let logger = Logger.create(.coreData)
  
  // MARK: - Static Accessors
  
  /// The shared controller that will persist data to disk.
  public static func create(target: AppTarget) -> PersistenceController {
    return PersistenceController(transactionAuthor: target.tranactionAuthor, contextName: target.contextName)
  }
  
  /// In memory store that does not write any data to disk
  public static var preview: PersistenceController = {
    let result = PersistenceController(transactionAuthor: nil, contextName: nil, inMemory: true)
    
    // Backfill history data
    for value in 2..<34 {
      let entity = Fast(context: result.container.viewContext)
      entity.startDate = Date().addingTimeInterval(-1 * 60 * 60 * 24)
      entity.endDate = entity.startDate?.addingTimeInterval(Double.random(in: 3...18) * 60 * 60)
      entity.targetInterval = 16 * 60 * 60
      entity.mood = Int16(Int.random(in: 0..<5))
      if Bool.random() {
        entity.note = "Preview Note"
      }
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
  
  private static func appGroupFileURL() -> URL {
    let appGroupDirectoryUrl: URL = FileManager.default
      .containerURL(forSecurityApplicationGroupIdentifier: "group.com.zachmcgaughey.Fasting.data")
      .unsafelyUnwrapped
    let dataUrl: URL = appGroupDirectoryUrl.appendingPathComponent("Fasting.sqlite")
    return dataUrl
  }
  
  private static func applicationURL() -> URL {
    let supportDirectory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
    let dataUrl = supportDirectory.appendingPathComponent("Fasting.sqlite")
    return dataUrl
  }
  
  
  // MARK: - Properties
  
  public let container: NSPersistentContainer
  
  // MARK: - Lifecycle
  
  private init(transactionAuthor: String?, contextName: String?, inMemory: Bool = false) {
    
    guard let objectModelUrl = Bundle(identifier: "com.zachmcgaughey.FastStorage")?.url(forResource: "Fasting", withExtension: "momd") else {
      preconditionFailure("Unable to find managed object model URL")
    }
    
    guard let objectModel = NSManagedObjectModel(contentsOf: objectModelUrl) else {
      preconditionFailure("Unable to get managed object model from URL")
    }
    
    self.container = NSPersistentContainer(name: "Fasting", managedObjectModel: objectModel)
    container.viewContext.name = contextName
    container.viewContext.transactionAuthor = transactionAuthor
    
    if inMemory {
      Self.logger.trace("Created memory persistent container")
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
      
    } else {
      try? container.viewContext.setQueryGenerationFrom(.current)
      
      let appGroupUrl = Self.appGroupFileURL()
      let appGroupPath = appGroupUrl.absoluteString.replacingOccurrences(of: "file://", with: "").removingPercentEncoding.unsafelyUnwrapped
      let newFileExists: Bool = FileManager.default.fileExists(atPath: appGroupPath)
      
      let supportUrl = Self.applicationURL()
      let supportPath = supportUrl.absoluteString.replacingOccurrences(of: "file://", with: "").removingPercentEncoding.unsafelyUnwrapped
      let oldFileExists: Bool = FileManager.default.fileExists(atPath: supportPath)
      
      if oldFileExists && newFileExists == false {
        migrateToAppGroup(container: container, supportURL: supportUrl, appGroupURL: appGroupUrl)
        return
      }
      
      let description = NSPersistentStoreDescription(url: appGroupUrl)
      description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
      description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
      container.persistentStoreDescriptions = [description]
    }
    
    let semephore = DispatchSemaphore(value: 1)
    
    container.loadPersistentStores { storeDescription, error in
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
      
      semephore.signal()
    }
    
    semephore.wait()
  }
  
  private func migrateToAppGroup(container: NSPersistentContainer, supportURL: URL, appGroupURL: URL) {
    let coordinator = container.persistentStoreCoordinator
    
    let oldStoreDescription = NSPersistentStoreDescription(url: supportURL)
    oldStoreDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
    oldStoreDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
    container.persistentStoreDescriptions = [oldStoreDescription]
    
    let semephore = DispatchSemaphore(value: 1)
    
    container.loadPersistentStores { storeDescription, error in
      guard let url = storeDescription.url else { return }
      guard let oldStore = coordinator.persistentStore(for: url) else { return }
      
      do {
        try coordinator.migratePersistentStore(oldStore, to: appGroupURL, options: nil, withType: NSSQLiteStoreType)
        try coordinator.destroyPersistentStore(at: url, ofType: NSSQLiteStoreType, options: nil)
        
      } catch {
        print("Error migrating store: \(error.localizedDescription)")
      }
      
      semephore.signal()
      
    }
    
    semephore.wait()
  }
  
}
