//
//  FastingGoal+RawRepresentable.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/22/21.
//

import Foundation

/*
 In order to use iOS 14's AppStorage with custom values, those values need
 to conform to RawRepresentable and the associatedType must be either
 String or Int. Since we conform to Codable, we can load to and from a String
 */
extension FastingGoal: RawRepresentable {
  
  public init?(rawValue: String) {
    
    guard let data = rawValue.data(using: .utf8) else {
      return nil
    }
    
    do {
      let result = try JSONDecoder().decode(Self.self, from: data)
      self = result
      
    } catch {
      Self.logger.error("Unable to decode FastingGoal from data: \(error.localizedDescription)")
      return nil
    }
    
  }

  public var rawValue: String {
    
    do {
      let data = try JSONEncoder().encode(self)
      
      guard let result = String(data: data, encoding: .utf8) else {
        Self.logger.error("Unable to produce String from FastingGoal data")
        return ""
      }
      
      return result
      
    } catch {
      Self.logger.error("Unable to encode FastingGoal to data: \(error.localizedDescription)")
      return ""
    }

  }
  
}
