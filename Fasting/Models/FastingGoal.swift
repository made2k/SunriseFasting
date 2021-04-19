//
//  FastingGoal.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/17/21.
//

import Foundation

enum FastingGoal: Codable {
  
  case fourteen
  case sixteen
  case nineteen
  case twenty
  case twentyThree
  case custom(duration: TimeInterval)
  
  // MARK: - Codable

  private enum CodingKeys: CodingKey {
    case base
    case customValue
  }
  
  private enum Base: String, Codable {
    case fourteen, sixteen, nineteen, twenty, twentyThree, custom
  }

  init(from decoder: Decoder) throws {
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let base = try container.decode(Base.self, forKey: .base)
    
    switch base {
    
    case .fourteen:
      self = .fourteen
      
    case .sixteen:
      self = .sixteen
      
    case .nineteen:
      self = .nineteen
      
    case .twenty:
      self = .twenty
      
    case .twentyThree:
      self = .twentyThree
      
    case .custom:
      let duration: TimeInterval = try container.decode(TimeInterval.self, forKey: .customValue)
      self = .custom(duration: duration)
    
    }
    
  }
  
  func encode(to encoder: Encoder) throws {
    
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    switch self {
    case .fourteen:
      try container.encode(Base.fourteen, forKey: .base)
      
    case .sixteen:
      try container.encode(Base.sixteen, forKey: .base)
      
    case .nineteen:
      try container.encode(Base.nineteen, forKey: .base)
      
    case .twenty:
      try container.encode(Base.twenty, forKey: .base)
      
    case .twentyThree:
      try container.encode(Base.twentyThree, forKey: .base)
      
    case .custom(let value):
      try container.encode(Base.custom, forKey: .base)
      try container.encode(value, forKey: .customValue)
      
    }
    
  }
  
  // MARK: - Properties
  
  var duration: TimeInterval {
    
    switch self {
    
    case .fourteen:
      return 14 * 60 * 60
      
    case .sixteen:
      return 16 * 60 * 60
      
    case .nineteen:
      return 19 * 60 * 60
      
    case .twenty:
      return 20 * 60 * 60
      
    case .twentyThree:
      return 23 * 60 * 60
      
    case .custom(let value):
      return value

    }
    
  }
  
}
