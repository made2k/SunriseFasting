//
//  ExportManager.swift
//  Fasting
//
//  Created by Zach McGaughey on 8/14/21.
//

import Foundation
import OSLog

final class ExportManager {
  
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
  
  init(model: AppModel) {
    self.model = model
  }
  
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
  
  func exportDataToUrl() -> URL? {
    
    Self.logger.trace("Exporing data")
    
    let exportedData: [ExportableFast] = model.completedFasts.compactMap(ExportableFast.init)
    
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

}
