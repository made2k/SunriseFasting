//
//  ExportManager.swift
//  Fasting
//
//  Created by Zach McGaughey on 8/14/21.
//

import CoreData
import FastStorage
import Foundation
import Logging
import OSLog

/// This class is responsible for importing and exporting data.
final class ExportManager {
  
  /// The date formatter is used to create the file name exported data is saved as.
  static private let dateFormatter: ISO8601DateFormatter = {
    let formatter: ISO8601DateFormatter = .init()
    formatter.formatOptions = [
      .withFullDate,
      .withDashSeparatorInDate
    ]
    return formatter
  }()
  
  private static let logger = Logger.create(.exporter)
  
  private let model: AppModel
  private let encoder: JSONEncoder = .init()
  private let decoder: JSONDecoder = .init()

  init(model: AppModel) {
    self.model = model
  }
  
  ///
  /// Clear the cached files created for export. Exporting will leave a json file
  /// in the cache directory. This will be cleaned by the system automatically, but
  /// this function is more proactive.
  ///
  static func clearCache() {
    
    logger.trace("Clearing export caches")
    
    // Delete all created files
    guard let caches = FileManager.default.urls(
      for: .cachesDirectory,
      in: .userDomainMask
    ).first else {
      logger.warning("No cache directory found")
      return
    }
    
    let enumerator = FileManager.default.enumerator(atPath: caches.path)
    
    while let file = (enumerator?.nextObject() as? String), file.hasSuffix(".json") {
      do {
        try FileManager.default.removeItem(atPath: "\(caches.path)/\(file)")
        
      } catch {
        logger.error("Failed to clean up cache file. \(error.localizedDescription, privacy: .public)")
      }
    }
    
  }

  /// Export the app data to a file for use with backups.
  /// - Note: This will only export completed Fasts (ie Fasts that have a start and end date).
  /// - Returns: A URL pointing to the file that was created.
  func exportDataToUrl() -> URL? {
    
    Self.logger.trace("Exporing data")
    
    let exportedData: [ExportableFast] = model.completedFasts.map(\.entity).compactMap(ExportableFast.init)
    
    let data: Data

    do {
      data = try encoder.encode(exportedData)
      
    } catch {
      Self.logger.error("Failed to encode data. Error: \(error.localizedDescription, privacy: .public)")
      return nil
    }
    
    let caches = FileManager.default.urls(
      for: .cachesDirectory,
      in: .userDomainMask
    ).first
    
    let fileName = Self.dateFormatter.string(from: Date())
    guard let path = caches?.appendingPathComponent("/Sunrise_\(fileName).json") else {
      Self.logger.warning("Unable to create file path")
      return nil
    }
    
    do {
      try data.write(to: path, options: .atomicWrite)
      Self.logger.info("Wrote exported data to \(path, privacy: .public)")
      return path
      
    } catch {
      Self.logger.error("Failed to write exported data. \(error.localizedDescription, privacy: .public)")
      return nil
    }
  }
  
  
  /// Import data and add it to the context of the app model provided during initialization.
  /// - Parameter data: Data previously exported fro the app.
  func importData(_ data: Data) {
    
    Self.logger.trace("Importing data")
    
    let imported: [ExportableFast]
    
    do {
      imported = try decoder.decode([ExportableFast].self, from: data)
      
    } catch {
      Self.logger.error("Failed to parse fasting data \(error.localizedDescription, privacy: .public)")
      return
    }
    
    Self.logger.debug("Import found \(imported.count, privacy: .public) items to import")

    batchInsertData(imported, using: model.manager.persistenceController.container)
  }

  private func createBatchInsert(with fasts: [ExportableFast]) -> NSBatchInsertRequest {

    var index = 0
    let total = fasts.count

    let batchInsert = NSBatchInsertRequest(entity: Fast.entity()) { (managedObject: NSManagedObject) -> Bool in

      guard index < total else { return true }

      if let fast = managedObject as? Fast {

        let data = fasts[index]
        fast.startDate = data.startDate
        fast.endDate = data.endDate
        fast.targetInterval = data.targetInterval

      }

      index += 1
      return false
    }

    return batchInsert

  }

  private func batchInsertData(
    _ fastingData: [ExportableFast],
    using container: NSPersistentContainer
  ) {

    guard fastingData.isEmpty == false else { return }

    container.performBackgroundTask { context in
      context.transactionAuthor = "export_manager"
      context.name = "import"

      let request = self.createBatchInsert(with: fastingData)

      do {
        try context.execute(request)
        Self.logger.trace("Batch import complete")

      } catch {
        Self.logger.error("Error batch importing data: \(error.localizedDescription)")
      }

    }
  }

}
