//
//  FastEntry.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/22/21.
//

import Combine
import CoreData
import Foundation
import OSLog

/// Wrapper data model around our CoreData entity
final class FastModel: ObservableObject {

  let logger = Logger.create(.dataModel)
    
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

    logger.trace("FastModel created from: \(fast.description, privacy: .private)")
    
    setupPersistSubscription()
  }
  
  deinit {
    logger.trace("FastModel deinit")
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
        self?.logger.debug("FastModel publishers caused persist to disk.")
        self?.persistToDisk(startDate, endDate: endDate, duration: duration)
      }
  }
  
  private func persistToDisk(_ startDate: Date, endDate: Date?, duration: TimeInterval) {
    logger.debug("FastModel is updating entity on disk")
    
    guard let context = entity.managedObjectContext else {
      logger.warning("FastModel entity did not have a managedObjectContext. Aborting save")
      return
    }
    
    entity.startDate = startDate
    entity.endDate = endDate
    entity.targetInterval = duration
    
    guard context.hasChanges else {
      logger.debug("FastModel has no changes, aborting update")
      return
    }

    do {
      try context.save()
      logger.trace("FastModel save completed")
      
    } catch {
      logger.error("Error saving entity to disk: \(error.localizedDescription)")
    }
    
  }

}
