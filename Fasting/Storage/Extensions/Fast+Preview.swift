//
//  Fast+Preview.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/23/21.
//

import Foundation

extension Fast {
  
  static let preview: Fast = {
    
    let fast = Fast(context: PersistenceController.preview.container.viewContext)
    fast.startDate = Date().dateByAdding(-1, .day).date
    fast.endDate = Date().dateByAdding(-8, .hour).date
    fast.targetInterval = 16.hours.timeInterval
    
    return fast
  }()
  
}
