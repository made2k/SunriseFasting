//
//  FastEntry.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/22/21.
//

import CoreData
import Foundation
import Combine

/// Wrapper data model around our CoreData entity
final class FastModel: ObservableObject {
    
  /// Our managed object reference
  let entity: Fast
  
  @Published var startDate: Date
  @Published var endDate: Date?
  @Published var duration: TimeInterval

  private var cancellable: AnyCancellable?

  // MARK: - Lifecycle
  
  init(_ fast: Fast) {
    self.entity = fast
    self.startDate = fast.startDate!
    self.endDate = fast.endDate
    self.duration = fast.targetInterval
    
    setupPersistSubscription()
  }
  
  deinit {
    cancellable?.cancel()
  }
  
  // MARK: - Data Persistance
  
  /// Since this data model mirrors our CoreData entity, when changes are made
  /// to this class, we want to persist those in CoreData. This sets up bindings to
  /// allow for that.
  private func setupPersistSubscription() {
    
    cancellable = Publishers.CombineLatest3($startDate, $endDate, $duration)
      .dropFirst() // This subscription only cares for updates, not initial value
      .sink { [weak self] (startDate: Date, endDate: Date?, duration: TimeInterval) in
        self?.persistToDisk(startDate, endDate: endDate, duration: duration)
      }
  }
  
  private func persistToDisk(_ startDate: Date, endDate: Date?, duration: TimeInterval) {
    print("FastModel is updating entity on disk")
    
    guard let context = entity.managedObjectContext else {
      print("FastModel entity did not have a managedObjectContext. Aborting save")
      return
    }
    
    entity.startDate = startDate
    entity.endDate = endDate
    entity.targetInterval = duration
    
    guard context.hasChanges else {
      print("FastModel has no changes, aborting update")
      return
    }

    do {
      try context.save()
      
    } catch {
      print("Error saving entity to disk: \(error)")
    }
    
  }

}
