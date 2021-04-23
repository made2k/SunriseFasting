//
//  ConstantUpdater.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/23/21.
//

import Foundation
import SwiftUI

/// An Updater that does not update. It contains a constant, unchanging value.
final class ConstantUpdater: ProgressUpdater {
  
  @Published var progress: Double
  var progressPublished: Published<Double> { _progress }
  var progressPublisher: Published<Double>.Publisher { $progress }
  
  init(_ progress: Double) {
    self.progress = progress
  }
  
  func connect() { }
  func disconnect() { }
  
}
