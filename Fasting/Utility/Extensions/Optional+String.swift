//
//  Optional+String.swift
//  Fasting
//
//  Created by Zach McGaughey on 9/10/22.
//

import Foundation

extension Optional where Wrapped == String {
  
  var isNilOrEmpty: Bool {
    guard let self = self else { return true }
    return self.isEmpty
  }
  
}
