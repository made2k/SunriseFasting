//
//  FastingGoal+Codable.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/22/21.
//

import Foundation

// Conforming to codable allows our FastingGoal
// to be stored in UserDefaults easily
extension FastingGoal: Codable {
  
  private enum CodingKeys: CodingKey {
    // Key to use for the base enum value type
    case base
    // Key to use for any associated values
    case customValue
  }
  
  /// The Base enum is stored encoded along with any associated values which are stored
  /// separately. We can extrapolate our type from this type as it should mirror our cases exactly
  /// but without any associated values.
  private enum Base: String, Codable {
    case fourteen, sixteen, nineteen, twentyThree, custom
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
      
    case .twentyThree:
      try container.encode(Base.twentyThree, forKey: .base)
      
    case .custom(let value):
      try container.encode(Base.custom, forKey: .base)
      try container.encode(value, forKey: .customValue)
      
    }
    
  }
  
}
