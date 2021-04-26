//
//  ConstantUpdater.swift
//  RingView
//
//  Created by Zach McGaughey on 4/26/21.
//

import Combine
import Foundation
import SwiftUI

/// An Updater that does not update. It contains a constant, unchanging value.
public final class ConstantUpdater: ProgressUpdater {
  
  @Published public var progress: Double
  public var progressPublished: Published<Double> { _progress }
  public var progressPublisher: Published<Double>.Publisher { $progress }
  
  public init(_ progress: Double) {
    self.progress = progress
  }

}
