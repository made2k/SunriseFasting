//
//  FastModel+Equatable.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/22/21.
//

import Foundation

extension FastModel: Equatable {
  
  static func == (lhs: FastModel, rhs: FastModel) -> Bool {
    return lhs.entity == rhs.entity
  }
  
}
