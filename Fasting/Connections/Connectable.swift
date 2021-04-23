//
//  Connectable.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/23/21.
//

import Foundation

/// Protocol allowing for connects and disconnects. Useful for Publishers
protocol Connectable {
  func connect()
  func disconnect()
}
