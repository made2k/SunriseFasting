//
//  Fast+Initialization.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/22/21.
//

import CoreData
import Foundation

extension Fast {
  
  convenience init(_ startDate: Date, endDate: Date? = nil, interval: TimeInterval, context: NSManagedObjectContext) {
    self.init(context: context)
    
    self.startDate = startDate
    self.endDate = endDate
    self.targetInterval = interval
  }
  
}
