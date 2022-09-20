//
//  View+Keyboard.swift
//  Fasting
//
//  Created by Zach McGaughey on 9/19/22.
//

import SwiftUI

extension View {
  
  @ViewBuilder func keyboardDismissal() -> some View {
    
    if #available(iOS 16.0, *) {
      self.scrollDismissesKeyboard(.interactively)
      
    } else {
      self
    }
    
  }
  
}
