//
//  FastModel+Previewing.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/22/21.
//

import FastingKit
import Foundation

extension FastModel {
  
  /// Create and return a model that uses our preview NSManagedObjectContext.
  /// This should be used whenever a FastModel is used in preview contexts.
  static var preview: FastModel {
    let context = PersistenceController.preview.container.viewContext
    let entity = Fast(Date().dateByAdding(-24, .minute).date, endDate: nil, interval: 1.hours.timeInterval, context: context)
    return FastModel(entity)
  }
 
}
