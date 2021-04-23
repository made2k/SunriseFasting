//
//  TextButtonGroup.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/21/21.
//

import SwiftUI

struct TextButtonGroup: View {
  
  private let textValue: String
  private let buttonValue: String
  private let action: () -> Void
  
  init(_ text: String, buttonTitle: String, action: @escaping () -> Void) {
    self.textValue = text
    self.buttonValue = buttonTitle
    self.action = action
  }
  
  var body: some View {
    
    VStack {
      Text(textValue)
        .fontWeight(.bold)
      Button(buttonValue, action: action)
    }
    
  }
  
}

struct TextButtonGroup_Previews: PreviewProvider {
  
  @State static var fastingGoal: FastingGoal = FastingGoal.sixteen
  
  static var previews: some View {
    TextButtonGroup("Current Fast", buttonTitle: fastingGoal.caseTitle, action: {})
  }
  
}
