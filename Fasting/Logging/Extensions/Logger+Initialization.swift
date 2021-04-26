//
//  Logger+Initialization.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/24/21.
//

import Foundation
import OSLog

enum LogCategory: String {
  case application = "Application"
  case coreData = "CoreData"
  case dataModel = "DataModel"
  case interface = "Interface"
  case widget = "Widget"
}

extension Logger {

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
