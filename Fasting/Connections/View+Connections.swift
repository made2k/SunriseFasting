//
//  View+Connections.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/23/21.
//

import SwiftUI

extension View {
  
  /// Connect and disconnect automatically when a view appears and disappears
  /// - Parameter connectable: The Connectable
  func autoConnect(_ connectable: Connectable) -> some View {
    
    return self
      .onAppear(perform: connectable.connect)
      .onDisappear(perform: connectable.disconnect)
    
  }
  
}
