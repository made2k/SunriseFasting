//
//  WatchDataProvider.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/28/21.
//

import Combine
import CoreData
import FastStorage
import Foundation
import Logging
import OSLog
import SharedData
import WatchConnectivity

/// This class observes our managed object for changes and will
/// send an updated state to the watch when changed.
final class WatchDataProvider {

  private static let logger = Logger.create(.watch)
  private let container: NSPersistentContainer
  private let session = WCSession.default

  private var existingData: SharedWidgetDataType?

  private var cancellable: AnyCancellable?

  init(_ container: NSPersistentContainer) {
    self.container = container

    cancellable = NotificationCenter.default
      .publisher(for: .NSManagedObjectContextDidSave, object: container.viewContext)
      .sink { [weak self] _ in
        Self.logger.debug("Widget data update triggered from notification center")
        self?.reloadData()
      }

    reloadData()
  }
  
  func forceDataUpdate() {
    reloadData(force: true)
  }

  private func reloadData(force: Bool = false) {
    
    container.performBackgroundTask { [weak self] context in

      let activeFastRequest: NSFetchRequest<Fast> = Fast.fetchRequest()
      activeFastRequest.predicate = NSPredicate(format: "endDate == nil")

      let completedFastsRequest: NSFetchRequest<Fast> = Fast.fetchRequest()
      completedFastsRequest.predicate = NSPredicate(format: "endDate != nil")
      completedFastsRequest.fetchLimit = 1

      let sortDescriptor = NSSortDescriptor(keyPath: \Fast.endDate, ascending: false)
      completedFastsRequest.sortDescriptors = [sortDescriptor]

      do {

        let activeResults: [Fast] = try context.fetch(activeFastRequest)

        if let currentFast: Fast = activeResults.first {

          let fastInfo = SharedFastInfo(currentFast.startDate!, interval: currentFast.targetInterval)
          let data: SharedWidgetDataType = .active(fastInfo: fastInfo)
          try self?.sendIfNeeded(data, force: force)

          return
        }

        let completedResults: [Fast] = try context.fetch(completedFastsRequest)

        let completedDate: Date? = completedResults.first?.endDate
        let data = SharedWidgetDataType.idle(lastFastDate: completedDate)
        try self?.sendIfNeeded(data, force: force)

      } catch {
        Self.logger.error("Error writing shared data to disk: \(error.localizedDescription)")
      }

    }

  }

  private func sendIfNeeded(_ payloadData: SharedWidgetDataType, force: Bool) throws {

    if !force {

      // Check that our data needs to be sent
      guard payloadData != existingData else {
        Self.logger.debug("The existing watch data was the same as our new data, not updating")
        return
      }

    }

    existingData = payloadData

    Self.logger.debug("Sending new data to watch")

    let encoder = JSONEncoder()
    let data = try encoder.encode(payloadData)
    
    if session.isReachable {
      
      Self.logger.debug("Companion is open, sending direct message")
      
      session.sendMessageData(data, replyHandler: nil) { error in
        Self.logger.error("Error sending data to watch: \(error.localizedDescription)")
      }
      
    } else {
      
      let dictValue: [String: Any]
      
      do {
        guard let serialization = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
          return
        }
        dictValue = serialization
        
      } catch {
        Self.logger.error("Unable to serialize JSON: \(error.localizedDescription)")
        return
      }
      
      if session.isComplicationEnabled && session.remainingComplicationUserInfoTransfers > 0 {
        Self.logger.debug("Sending complication update")
        session.transferCurrentComplicationUserInfo(dictValue)
        
      } else {
        
        Self.logger.debug("Queuing update")
        
        // Cancel our outstanding user info transfers. Updated data takes precedence
        session.outstandingUserInfoTransfers.forEach { $0.cancel() }
        session.transferUserInfo(dictValue)

      }

    }

  }

}
