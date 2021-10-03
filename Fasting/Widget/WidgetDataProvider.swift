//
//  WidgetDataProvider.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/26/21.
//

import Combine
import CoreData
import FastStorage
import Logging
import OSLog

final class WidgetDataProvider {

  private static let logger = Logger.create(.widget)
  private let container: NSPersistentContainer
  
  private var cancellables = Set<AnyCancellable>()
  
  init(_ container: NSPersistentContainer) {
    self.container = container
    
    NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave, object: container.viewContext).sink { [weak self] _ in
      Self.logger.debug("Widget data update triggered from notification center")
      self?.reloadData()
    }
    .store(in: &cancellables)
    
  }
  
  private func reloadData() {
    
    container.performBackgroundTask { context in
      SharedDataWriter.writeData(with: context)
    }
    
  }
  
}
