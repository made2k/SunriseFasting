//
//  FastingGoal.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/17/21.
//

import Foundation

enum FastingGoal: Codable {
  
  static var current: FastingGoal {
    get {
      UserDefaults.standard.getObject(forKey: "\(Bundle.main.bundleIdentifier!).fastingGoal.current") ?? .sixteen
    }
    set {
      try? UserDefaults.standard.setObject(newValue, forKey: "\(Bundle.main.bundleIdentifier!).fastingGoal.current")
    }
  }
  
  case fourteen
  case sixteen
  case nineteen
  case twentyThree
  case custom(duration: TimeInterval)
  
  // MARK: - Codable
  
  private enum CodingKeys: CodingKey {
    case base
    case customValue
  }
  
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

  // MARK: - All Cases
  
  static func all() -> [FastingGoal] {
    return [
      .fourteen,
      .sixteen,
      .nineteen,
      .twentyThree,
      .custom(duration: 0)
    ]
  }
  
  // MARK: - Initialization
  
  init(from interval: TimeInterval) {
    
    for type in Self.all() {
      if type.duration == interval {
        self = type
        return
      }
    }
    
    self = .custom(duration: interval)

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
      
    case .twentyThree:
      return 23 * 60 * 60
      
    case .custom(let value):
      return value
      
    }
    
  }
  
}

// MARK: - Descriptors

extension FastingGoal {
  
  var title: String {
    
    switch self {
    
    case .fourteen:
      return Bundle.main.localizedString(forKey: "fourteen title", value: nil, table: "FastingGoal")
      
    case .sixteen:
      return Bundle.main.localizedString(forKey: "sixteen title", value: nil, table: "FastingGoal")
      
    case .nineteen:
      return Bundle.main.localizedString(forKey: "nineteen title", value: nil, table: "FastingGoal")

    case .twentyThree:
      return Bundle.main.localizedString(forKey: "twenty three title", value: nil, table: "FastingGoal")
      
    case .custom(_):
      return Bundle.main.localizedString(forKey: "custom title", value: nil, table: "FastingGoal")
    }
    
  }
  
  var description: String {
    
    switch self {
    
    case .fourteen:
      return Bundle.main.localizedString(forKey: "fourteen description", value: nil, table: "FastingGoal")
      
    case .sixteen:
      return Bundle.main.localizedString(forKey: "sixteen description", value: nil, table: "FastingGoal")
      
    case .nineteen:
      return Bundle.main.localizedString(forKey: "nineteen description", value: nil, table: "FastingGoal")

    case .twentyThree:
      return Bundle.main.localizedString(forKey: "twenty three description", value: nil, table: "FastingGoal")
      
    case .custom(_):
      return Bundle.main.localizedString(forKey: "custom description", value: nil, table: "FastingGoal")
    }
    
  }
  
}
