//
//  SiriDataManager.swift
//  FastingIntents
//
//  Created by Zach McGaughey on 9/27/21.
//

import FastStorage
import Logging
import Foundation
import CoreData
import OSLog

internal class SiriDataManager {
  
  static let shared: SiriDataManager = .init()
  
  let persistenceController: PersistenceController = .create(target: .siriExtension)
  
  private init() { }
  
  func getCurrentFast() throws -> Fast? {
    
    let context = persistenceController.container.viewContext
    
    let request: NSFetchRequest<Fast> = Fast.fetchRequest()
    request.predicate = NSPredicate(format: "endDate == nil")
    
    let results: [Fast] = try context.fetch(request)
    
    // Data check here. We should only ever have 1 or 0 current fasts
    // If we have more, our data has become corrupted.
    guard results.count <= 1 else {
      throw IntentError.dataCorruption
    }
    
    return results.first
  }
  
  func createNewFast() throws -> Fast {
    
    let context = persistenceController.container.viewContext
    
    let fast = Fast(context: context)
    fast.startDate = Date()

    let fastGoal: FastingGoal
    
    if let savedString = StorageDefaults.sharedDefaults.string(forKey: UserDefaultKey.fastingGoal.rawValue) {
      fastGoal = FastingGoal(rawValue: savedString) ?? .default

    } else {
      fastGoal = .default
    }
    
    fast.targetInterval = fastGoal.duration
        
    try context.save()

    reloadWidget(with: context)
    
    return fast
    
  }
  
  func endExistingFast(_ fast: Fast) throws {
    
    let context = persistenceController.container.viewContext
    
    fast.endDate = Date()
        
    try context.save()

    reloadWidget(with: context)
    
  }

  private func reloadWidget(with context: NSManagedObjectContext) {
    SharedDataWriter.writeData(with: context)
  }
  
}
