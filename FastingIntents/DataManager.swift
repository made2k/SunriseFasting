//
//  DataManager.swift
//  FastingIntents
//
//  Created by Zach McGaughey on 9/27/21.
//

import Foundation
import CoreData

internal class DataManager {
  
  static let shared: DataManager = .init()
  
  let container: NSPersistentContainer?
  
  private init() {
    
    let dataUrl: URL = FileManager.default
      .containerURL(forSecurityApplicationGroupIdentifier: "group.com.zachmcgaughey.Fasting.data")
      .unsafelyUnwrapped
      .appendingPathComponent("Fasting.sqlite")
    
    let dataPath = dataUrl.absoluteString.replacingOccurrences(of: "file://", with: "").removingPercentEncoding.unsafelyUnwrapped
    
    guard FileManager.default.fileExists(atPath: dataPath) else {
      container = nil
      return
    }
    
    let container = NSPersistentContainer(name: "Fasting")
    
    let description = NSPersistentStoreDescription(url: dataUrl)
    container.persistentStoreDescriptions = [description]
    
    let semephore = DispatchSemaphore(value: 1)
    
    container.loadPersistentStores { storeDescription, error in
      if let error = error as NSError? {
        //        Self.logger.error("Failed to load persistent stores: \(error.localizedDescription)")
        print("Failed to load persistent stores: \(error.localizedDescription)")
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
        //        Self.logger.debug("Persistent stores loaded: \(storeDescription)")
        print("Persistent stores loaded: \(storeDescription)")
      }
      
      semephore.signal()
    }
    
    semephore.wait()
    self.container = container
    
  }
  
  func getCurrentFast() throws -> Fast? {
    
    guard let context = container?.viewContext else { throw IntentLoadError.unknownError }
    
    let request: NSFetchRequest<Fast> = Fast.fetchRequest()
    request.predicate = NSPredicate(format: "endDate == nil")
    
    let results: [Fast] = try context.fetch(request)
    
    // Data check here. We should only ever have 1 or 0 current fasts
    // If we have more, our data has become corrupted.
    guard results.count <= 1 else {
      throw IntentLoadError.unknownError
    }
    
    return results.first
  }
  
  func createNewFast() throws {
    guard let context = container?.viewContext else { throw IntentLoadError.unknownError }
    
    let fast = Fast(context: context)
    fast.startDate = Date()
    // TODO: Fix this to load values
    fast.targetInterval = 16*60*60
    
    try context.save()
  }
  
}

enum IntentLoadError: Error {
  case unknownError
}
