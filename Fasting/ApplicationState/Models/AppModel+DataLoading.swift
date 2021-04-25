//
//  AppModel+DataLoading.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/22/21.
//

import CoreData
import Foundation

extension AppModel {
  
  /// Loads our persisted data and sets the values on the model.
  ///
  /// This will load and set values for `currentFast` and `completedFasts`
  /// overwriting any values not saved to disk.
  func loadDataFromStore() {
    loadCurrentFast()
    loadCompletedFasts()
  }
  
  
  /// Load and set the `currentFast` if it exists from disk.
  func loadCurrentFast() {

    logger.trace("Loading current fast data")
    
    let request: NSFetchRequest<Fast> = Fast.fetchRequest()
    request.predicate = NSPredicate(format: "endDate == nil")
    
    do {
      let results: [Fast] = try manager.fetch(request)
      
      // Data check here. We should only ever have 1 or 0 current fasts
      // If we have more, our data has become corrupted.
      guard results.count <= 1 else {
        logger.fault("Corrupted data, multiple in progress fasts")
        preconditionFailure("data corruption")
      }
      
      if let fast = results.first {
        logger.debug("Current fast loaded. Setting value")
        self.currentFast = FastModel(fast)
        
      } else {
        logger.debug("No current fast loaded")
        self.currentFast = nil
      }
      
    } catch {
      logger.error("Failed to fetch current fast: \(error.localizedDescription)")
    }
  }
  
  /// Load and set all `completedFasts` from disk
  func loadCompletedFasts() {

    logger.trace("Loading completed fast data")
    
    let request: NSFetchRequest<Fast> = Fast.fetchRequest()
    request.predicate = NSPredicate(format: "endDate != nil")
    
    let sortDescriptor = NSSortDescriptor(keyPath: \Fast.endDate, ascending: false)
    request.sortDescriptors = [sortDescriptor]
    
    do {
      let results: [Fast] = try manager.fetch(request)
      logger.debug("Loaded \(results.count) completed fasts")
      self.completedFasts = results
      
    } catch {
      logger.error("failed to fetch completed fasts: \(error.localizedDescription)")
    }

  }
  
}
