//
//  View+ContitionalModifiers.swift
//  Fasting
//
//  Created by Zach McGaughey on 9/11/22.
//

import SwiftUI

extension View {
  
  @ViewBuilder func isHidden(_ hidden: Bool) -> some View {
    
    if hidden {
      self.hidden()
      
    } else {
      self
    }

  }

}
