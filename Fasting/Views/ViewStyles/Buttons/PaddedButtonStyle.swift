//
//  PaddedButtonStyle.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/21/21.
//

import SwiftUI

struct PaddedButtonStyle: ButtonStyle {
  
  let backgroundColor: Color
  
  init(_ backgroundColor: Color = Color(UIColor.systemGray5)) {
    self.backgroundColor = backgroundColor
  }
  
  func makeBody(configuration: Configuration) -> some View {
    
    withAnimation {
      
      configuration.label
        .foregroundColor(Color(UIColor.secondaryLabel))
        .font(Font.subheadline.weight(.semibold))
        .padding([.leading, .trailing], 16)
        .padding([.top, .bottom], 8)
        .background(
          RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(backgroundColor)
        )
        .scaleEffect(
          x: configuration.isPressed ? 0.95 : 1,
          y: configuration.isPressed ? 0.95 : 1,
          anchor: .center
        )
      
    }
    
  }
  
}
