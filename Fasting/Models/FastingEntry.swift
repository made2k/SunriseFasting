//
//  FastingEntry.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/17/21.
//

import Foundation

class FastingModel {
  
  private let entity: Fast

  var startTime: Date
  var endTime: Date?
  var targetEndTime: Date { startTime.addingTimeInterval(duration) }
  var duration: TimeInterval
  
  init(startTime: Date = Date(), endTime: Date? = nil, goal: FastingGoal) {
    self.entity = DataManger.shared.newFast(startTime, endTime: endTime, interval: goal.duration)
    
    self.startTime = startTime
    self.endTime = nil
    self.duration = goal.duration
  }
  
  init(_ fast: Fast) {
    self.entity = fast
    
    self.startTime = fast.startTime!
    self.endTime = fast.endTime
    self.duration = fast.targetInterval
  }
  
  func saveToDisk() {
    entity.startTime = startTime
    entity.endTime = endTime
    entity.targetInterval = duration
    
    DataManger.shared.save(entity)
  }
  
  func delete() {
    DataManger.shared.delete(entity)
  }
  
}
