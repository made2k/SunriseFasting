//
//  FastGroup.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/23/21.
//

import FastStorage
import Foundation

/// Groups a list of fasts into a structured object. Used
/// for displaying a list of items.
struct FastGroup {
  
  let title: String
  let fasts: [FastModel]
  
}
