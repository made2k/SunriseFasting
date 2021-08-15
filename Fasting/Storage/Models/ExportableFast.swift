//
//  ExportableFast.swift
//  Fasting
//
//  Created by Zach McGaughey on 8/14/21.
//

import CoreData
import Foundation

struct ExportableFast: Codable {
  
  let startDate: Date
  let endDate: Date
  let targetInterval: TimeInterval
  
  init?(_ fast: Fast) {
    guard let startDate = fast.startDate else { return nil }
    self.startDate = startDate
    
    guard let endDate = fast.endDate else { return nil }
    self.endDate = endDate
    
    self.targetInterval = fast.targetInterval
  }
  
  func asFast(with context: NSManagedObjectContext) -> Fast {
    Fast(
      startDate,
      endDate: endDate,
      interval: targetInterval,
      context: context
    )
  }
  
}
