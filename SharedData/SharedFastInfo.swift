//
//  SharedFastInfo.swift
//  SharedData
//
//  Created by Zach McGaughey on 4/26/21.
//

import Foundation

/// Codable struct that allows for sharing data between the main application and
/// other targets like the widgets.
public struct SharedFastInfo: Codable {
  public let startDate: Date
  public let targetInterval: TimeInterval
  
  public init(_ startDate: Date, interval: TimeInterval) {
    self.startDate = startDate
    self.targetInterval = interval
  }
  
}

extension SharedFastInfo: Equatable { }
