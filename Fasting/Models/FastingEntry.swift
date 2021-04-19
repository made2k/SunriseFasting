//
//  FastingEntry.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/17/21.
//

import Foundation

struct FastingModel: Codable {
  
  let startTime: Date
  let endTime: Date
  let goal: FastingGoal
  
  init(startTime: Date = Date(), goal: FastingGoal) {
    self.startTime = startTime
    self.endTime = startTime.addingTimeInterval(goal.duration)
    self.goal = goal
  }
  
}
