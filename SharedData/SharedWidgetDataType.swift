//
//  SharedWidgetDataType.swift
//  SharedData
//
//  Created by Zach McGaughey on 4/26/21.
//

import Foundation

public enum SharedWidgetDataType {
  case idle(lastFastDate: Date?)
  case active(fastInfo: SharedFastInfo)
}

extension SharedWidgetDataType: Codable {
  
  private enum CodingKeys: CodingKey {
    case base
    case value
  }
  
  private enum Base: String, Codable {
    case idle, active
  }
  
  public init(from decoder: Decoder) throws {
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let base = try container.decode(Base.self, forKey: .base)
    
    switch base {
    
    case .active:
      let fastInfo: SharedFastInfo = try container.decode(SharedFastInfo.self, forKey: .value)
      self = .active(fastInfo: fastInfo)
    
    case .idle:
      let fastDate: Date? = try container.decodeIfPresent(Date.self, forKey: .value)
      self = .idle(lastFastDate: fastDate)
    
    }

  }
  
  public func encode(to encoder: Encoder) throws {
    
    var container = encoder.container(keyedBy: CodingKeys.self)

    switch self {
    
    case .idle(let lastFast):
      try container.encode(Base.idle, forKey: .base)
      try container.encodeIfPresent(lastFast, forKey: .value)
      
    case .active(let fastInfo):
      try container.encode(Base.active, forKey: .base)
      try container.encode(fastInfo, forKey: .value)
      
    }
    
  }
  
}

extension SharedWidgetDataType: Equatable { }
