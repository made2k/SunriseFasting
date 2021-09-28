//
//  DataManager.swift
//  FastingIntents
//
//  Created by Zach McGaughey on 9/27/21.
//

import FastStorage
import Foundation
import CoreData

internal class DataManager {
  
  static let shared: DataManager = .init()
  
  let persistenceController: PersistenceController = .create()
  
  private init() { }
  
  func getCurrentFast() throws -> Fast? {
    
//    guard let context = persistenceController.container.viewContext else { throw IntentLoadError.unknownError }
    let context = persistenceController.container.viewContext
    
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
//    guard let context = container?.viewContext else { throw IntentLoadError.unknownError }
    let context = persistenceController.container.viewContext
    
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
