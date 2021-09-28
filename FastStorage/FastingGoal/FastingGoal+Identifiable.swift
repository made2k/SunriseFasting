//
//  FastingGoal+Identifiable.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/23/21.
//

import Foundation

extension FastingGoal: Identifiable {
  
  public var id: TimeInterval { duration }
  
}
