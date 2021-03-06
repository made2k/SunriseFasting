//
//  Logger+Initialization.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/24/21.
//

import Foundation
import OSLog

public enum LogCategory: String {
  case application = "Application"
  case coreData = "CoreData"
  case dataModel = "DataModel"
  case exporter = "Exporter"
  case interface = "Interface"
  case siriIntent = "SiriIntent"
  case watch = "Watch"
  case widget = "Widget"
}

public extension Logger {

  /// Create a common logger using the bundle identifier as the subsystem.
  /// - Parameter category: Category to use for the logger.
  /// - Returns: A new Logger
  static func create(_ category: LogCategory = .application) -> Logger {
    let bundle = Bundle.main.bundleIdentifier!
    return Logger(subsystem: bundle, category: category.rawValue)
  }

  static let viewLogger: Logger = {
    create(.interface)
  }()

}
