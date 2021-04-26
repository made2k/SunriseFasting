//
//  RingViewStyles.swift
//  RingView
//
//  Created by Zach McGaughey on 4/26/21.
//

import Foundation
import SwiftUI

public extension RingView {
  
  func applyProgressiveStyle(_ percent: Double) -> Self {
    
    self
      .startColor(percent < 1 ? .ringIncompleteStart : .ringCompleteStart)
      .endColor(percent < 1 ? .ringIncompleteEnd : .ringCompleteEnd)
      .backgroundColor(percent < 1 ? Color.ringIncompleteStart.opacity(0.1) : Color.ringIncompleteEnd.opacity(0.1))

  }
  
}
