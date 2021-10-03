//
//  SharedDataWriter.swift
//  FastStorage
//
//  Created by Zach McGaughey on 10/3/21.
//

import CoreData
import Foundation
import OSLog
import SharedData
import WidgetKit

public enum SharedDataWriter {

  static private let sharedDataFileURL: URL = {
    let appGroupIdentifier = "group.com.zachmcgaughey.Fasting"
    if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier) {
      return url.appendingPathComponent("SharedData.json")

    } else {
      preconditionFailure("Expected a valid app group container")
    }

  }()

  private static let logger: Logger = Logger.create(.widget)

  public static func writeData(with context: NSManagedObjectContext) {

    let activeFastRequest: NSFetchRequest<Fast> = Fast.fetchRequest()
    activeFastRequest.predicate = NSPredicate(format: "endDate == nil")

    let completedFastsRequest: NSFetchRequest<Fast> = Fast.fetchRequest()
    completedFastsRequest.predicate = NSPredicate(format: "endDate != nil")
    completedFastsRequest.fetchLimit = 1

    let sortDescriptor = NSSortDescriptor(keyPath: \Fast.endDate, ascending: false)
    completedFastsRequest.sortDescriptors = [sortDescriptor]

    let existingData: SharedWidgetDataType? = {
      guard let storedData = try? Data(contentsOf: Self.sharedDataFileURL) else { return nil }
      return try? JSONDecoder().decode(SharedWidgetDataType.self, from: storedData)
    }()

    func writeIfNeeded(_ data: SharedWidgetDataType) throws {
      guard data != existingData else {
        Self.logger.debug("The existing widget data was the same as our new data, not updating")
        return
      }

      Self.logger.debug("Writing data to file and updating widgets")

      let encoder = JSONEncoder()
      let data = try encoder.encode(data)
      try data.write(to: Self.sharedDataFileURL)
      WidgetCenter.shared.reloadAllTimelines()
    }

    do {

      let activeResults: [Fast] = try context.fetch(activeFastRequest)

      if let currentFast: Fast = activeResults.first {

        let fastInfo = SharedFastInfo(currentFast.startDate!, interval: currentFast.targetInterval)
        let data: SharedWidgetDataType = .active(fastInfo: fastInfo)
        try writeIfNeeded(data)

        return
      }

      let completedResults: [Fast] = try context.fetch(completedFastsRequest)

      let completedDate: Date? = completedResults.first?.endDate
      let data = SharedWidgetDataType.idle(lastFastDate: completedDate)
      try writeIfNeeded(data)

    } catch {
      Self.logger.error("Error writing shared data to disk: \(error.localizedDescription)")
    }

  }

}
