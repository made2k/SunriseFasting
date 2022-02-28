//
//  Fast+Preview.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/23/21.
//

import FastStorage
import Foundation

extension Fast {
  
  static let preview: Fast = {
    preview(mood: nil, note: nil)
  }()

  static func preview(mood: Int16?, note: String?) -> Fast {
    let fast = Fast(context: PersistenceController.preview.container.viewContext)
    fast.startDate = Date().dateByAdding(-1, .day).date
    fast.endDate = Date().dateByAdding(-8, .hour).date
    fast.targetInterval = 16.hours.timeInterval
    fast.mood = mood ?? 0
    fast.note = note
    return fast
  }
  
}
