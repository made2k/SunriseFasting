//
//  FastModel+FastActions.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/22/21.
//

import Foundation

extension AppModel {
  
  /// Create a fast and set as the `currentFast` if the endDate is nil.
  ///
  /// This function will create and persist a Fast to disk. Generally used to start
  /// an ongoing Fast. If endDate is not nil, the fast will not be set as the current
  /// since an end date indicates the fast is complete.
  ///
  /// - Parameters:
  ///   - startDate: The Date the fast was started.
  ///   - endDate: Optional, Date the fast was completed, or nil if the fast is ongoing.
  ///   - interval: The target interval for the fast.
  /// - Returns: A new FastModel mirroring the Fast entity.
  @discardableResult
  func startFast(
    _ startDate: Date = Date(),
    endDate: Date? = nil,
    interval: TimeInterval
  ) -> FastModel {
    
    let entity: Fast = manager.createNewFast(startDate, endDate: endDate, interval: interval)
    let model = FastModel(entity)
    
    if endDate == nil {
      currentFast = model
      
    } else {
      // Since this fast has been saved, our list is now outdated.
      // Load our completed fasts and overwrite our stored value.
      loadCompletedFasts()
    }
    
    return model
  }
  
  /// End an ongoing fast.
  ///
  /// This will add an endDate to the model and remove the
  /// fast from the `currentFast` property.
  ///
  /// - Parameters:
  ///   - model: The FastModel to end
  ///   - endDate: The Date to apply to the FastModel
  func endFast(_ model: FastModel, endDate: Date) {

    guard model.endDate == nil else {
      print("attempting to end an already ended fast")
      return
    }
    
    model.endDate = endDate
    
    // Now that we've updated our fast, load our completed fasts to keep up to date
    loadCompletedFasts()
    
    // Clear out our current fast since it's no longer ongoing
    currentFast = nil
  }
  
  /// Delete a fast from storage.
  /// - Parameter model: The model that will be deleted
  func deleteFast(_ model: FastModel) {
    manager.delete(model.entity)

    if model == currentFast {
      currentFast = nil
    }
    
  }
  
}
