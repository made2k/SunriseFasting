//
//  Fonts.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/21/21.
//

import SwiftUI

extension View {
  
  func monospaced(font: Font) -> some View {
    self.font(Font.monospacedDigit(font)())
  }
  
}
