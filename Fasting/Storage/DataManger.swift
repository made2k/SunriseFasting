//
//  DataManger.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/19/21.
//

import CoreData
import Foundation

class DataManger {
  
  static var shared: DataManger = DataManger()
  
  lazy var persistentContainer: NSPersistentContainer = {
    
    let container = NSPersistentContainer(name: "Fasting")
    
    container.loadPersistentStores { _, error in
      
      if let error = error {
        preconditionFailure("Failed to load data store")
      }
      
    }
    
    return container
    
  }()
  
  private var context: NSManagedObjectContext {
    persistentContainer.viewContext
  }

}

// MARK: - Creation

extension DataManger {
  
  func newFast(_ startTime: Date, endTime: Date?, interval: TimeInterval) -> Fast {
    
    let fast = Fast(context: context)
    fast.startTime = startTime
    fast.endTime = endTime
    fast.targetInterval = interval
    
    return fast
    
  }
  
}

// MARK: - Saving / Deleting

extension DataManger {
  
  func save(_ fast: Fast) {
        
    guard context.hasChanges else { return }
    
    do {
      try context.save()
      
    } catch {
      print(error)
    }
    
  }

  func delete(_ fast: Fast) {
  
    context.delete(fast)
    
    do {
      try context.save()
      
    } catch {
      print(error)
    }
    
  }

}

// MARK: - Loading

extension DataManger {
  
  func loadCurrentFast() -> FastingModel? {
    
    let request: NSFetchRequest<Fast> = Fast.fetchRequest()
    request.predicate = NSPredicate(format: "endTime == nil")
    
    do {
      
      let currentFasts: [Fast] = try context.fetch(request)
      
      guard currentFasts.count <= 1 else {
        preconditionFailure("Corrupted data, multiple in progress fasts")
      }
      
      guard let fast = currentFasts.first else { return nil }
      return FastingModel(fast)
      
    } catch {
      print(error)
      return nil
    }
    
  }
  
  func loadAllFasts() -> [FastingModel] {
    
    let request: NSFetchRequest<Fast> = Fast.fetchRequest()
    
    let sortDescriptor = NSSortDescriptor(keyPath: \Fast.startTime, ascending: true)
    request.sortDescriptors = [sortDescriptor]
        
    do {
      
      let fasts: [Fast] = try context.fetch(request)
      return fasts.map(FastingModel.init)
      
    } catch {
      print(error)
      return []
    }
    
  }

  
}
