//
//  PaddedButtonStyle.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/21/21.
//

import SwiftUI

struct PaddedButtonStyle: ButtonStyle {
  
  let backgroundColor: Color
  let foregroundColor: Color
  
  init(
    backgroundColor: Color = Color.buttonBackground,
    foregroundColor: Color = Color(UIColor.secondaryLabel)
  ) {
    self.backgroundColor = backgroundColor
    self.foregroundColor = foregroundColor
  }
  
  func makeBody(configuration: Configuration) -> some View {
    
    withAnimation {
      
      configuration.label
        .foregroundColor(foregroundColor)
        .font(Font.subheadline.weight(.medium))
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
        .shadow(
          color: Color(UIColor.label).opacity(0.16),
          radius: configuration.isPressed ? 1 : 4,
          x: 0,
          y: 1
        )
      
    }
    
  }
  
}

struct PaddedButtonStyle_Previews: PreviewProvider {
  
  @State private static var value: Int?
  
  static var previews: some View {
    VStack {
      Button("Test Button") { }
        .buttonStyle(PaddedButtonStyle())
      Button("Test Button") { }
        .buttonStyle(PaddedButtonStyle(foregroundColor: .orange))
    }
    
  }
  
}
