//
//  WatchDataProvider.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/28/21.
//

import Combine
import CoreData
import Foundation
import OSLog
import SharedData
import WatchConnectivity

final class WatchDataProvider {

  private static let logger = Logger.create(.watch)
  private let container: NSPersistentContainer
  private let session = WCSession.default

  private var existingData: SharedWidgetDataType?

  private var cancellables = Set<AnyCancellable>()

  init(_ container: NSPersistentContainer) {
    self.container = container

    NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave, object: container.viewContext).sink { [weak self] _ in
      Self.logger.debug("Widget data update triggered from notification center")
      self?.reloadData()
    }
    .store(in: &cancellables)

    reloadData()
  }

  private func reloadData() {

    container.performBackgroundTask { [weak self] context in

      let activeFastRequest: NSFetchRequest<Fast> = Fast.fetchRequest()
      activeFastRequest.predicate = NSPredicate(format: "endDate == nil")

      let completedFastsRequest: NSFetchRequest<Fast> = Fast.fetchRequest()
      completedFastsRequest.predicate = NSPredicate(format: "endDate != nil")
      completedFastsRequest.fetchLimit = 1

      let sortDescriptor = NSSortDescriptor(keyPath: \Fast.endDate, ascending: false)
      completedFastsRequest.sortDescriptors = [sortDescriptor]

      func sendIfNeeded(_ data: SharedWidgetDataType) throws {
        guard data != self?.existingData else {
          Self.logger.debug("The existing widget data was the same as our new data, not updating")
          return
        }

        Self.logger.debug("Writing data to file and updating widgets")

        let encoder = JSONEncoder()
        let data = try encoder.encode(data)

        self?.session.sendMessageData(data, replyHandler: nil) { error in
          Self.logger.error("Error sending data to watch: \(error.localizedDescription)")
        }

      }

      do {

        let activeResults: [Fast] = try context.fetch(activeFastRequest)

        if let currentFast: Fast = activeResults.first {

          let fastInfo = SharedFastInfo(currentFast.startDate!, interval: currentFast.targetInterval)
          let data: SharedWidgetDataType = .active(fastInfo: fastInfo)
          try sendIfNeeded(data)

          return
        }

        let completedResults: [Fast] = try context.fetch(completedFastsRequest)

        let completedDate: Date? = completedResults.first?.endDate
        let data = SharedWidgetDataType.idle(lastFastDate: completedDate)
        try sendIfNeeded(data)

      } catch {
        Self.logger.error("Error writing shared data to disk: \(error.localizedDescription)")
      }

    }

  }

}
