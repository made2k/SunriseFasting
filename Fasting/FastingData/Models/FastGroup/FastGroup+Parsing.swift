//
//  FastGroup+Parsing.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/23/21.
//

import Algorithms
import FastStorage
import Formatting
import Foundation

extension FastGroup {
  
  static func group(_ collection: [FastModel]) -> [FastGroup] {

    let chunked = collection.chunked(on: { $0.entity.chunkedIdentifier })
    let groups = chunked.compactMap { (collection) -> FastGroup? in
      guard let first = collection.first else { return nil }
      return FastGroup(title: first.entity.chunkedIdentifier, fasts: Array(collection))
    }
    
    return groups
  }
  
}


private extension Fast {
  
  var chunkedIdentifier: String {
    StringFormatter.monthGroupTitleFormatter.string(from: startDate!)
  }
  
}
