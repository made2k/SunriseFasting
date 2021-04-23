//
//  NumberTextField.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/22/21.
//

import SwiftUI

/// TextField that binds to a numeric value (generic type)
struct NumberTextField<V>: UIViewRepresentable where V: Numeric & LosslessStringConvertible {
  
  typealias UIViewType = UITextField
  
  /// Placeholder text. Title keeping in line with native SwiftUI convention
  let title: String?
  /// Updating value of the TextField
  @Binding var value: V?
  
  private var borderStyle: UITextField.BorderStyle = UITextField.BorderStyle.roundedRect
  /// When enabled, this view will become the first responder
  private var isFirstResponder: Bool = false
  
  // MARK: - Lifecycle
  
  init(title: String?, value: Binding<V?>, isFirstResponder: Bool = false) {
    self.title = title
    self._value = value
    self.isFirstResponder = isFirstResponder
  }
  
  // MARK: - UIViewRepresentable
  
  func makeUIView(context: UIViewRepresentableContext<NumberTextField>) -> UITextField {
    let editField = UITextField()
    editField.placeholder = title
    editField.delegate = context.coordinator
    editField.keyboardType = .numberPad
    return editField
  }
  
  func updateUIView(_ textField: UITextField, context: UIViewRepresentableContext<NumberTextField>) {
    
    if let value = value {
      textField.text = String(value)
      
    } else {
      textField.text = nil
    }
    
    textField.borderStyle = borderStyle
    
    if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
      textField.becomeFirstResponder()
      context.coordinator.didBecomeFirstResponder = true
    }
    
    textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
    textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
  }
  
  // MARK: - Modifiers
  
  func borderStyle(_ value: UITextField.BorderStyle) -> Self {
    var view = self
    view.borderStyle = value
    return view
  }
  
  // MARK: - Coordinator

  func makeCoordinator() -> NumberTextField.Coordinator {
    Coordinator(value: $value)
  }
    
  class Coordinator: NSObject, UITextFieldDelegate {
    
    var value: Binding<V?>
    var didBecomeFirstResponder = false
    
    init(value: Binding<V?>) {
      self.value = value
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
      guard let text = textField.text, let textRange = Range(range, in: text) else {
        self.value.wrappedValue = nil
        return true
      }
      
      let updatedText = text.replacingCharacters(in: textRange, with: string)
      
      if let number = V(updatedText) {
        self.value.wrappedValue = number
        return true
        
      } else if updatedText.isEmpty {
        self.value.wrappedValue = nil
        return true
        
      } else {
        return false
      }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
      if reason == .committed {
        textField.resignFirstResponder()
      }
    }
  }
  
}

struct NumberTextField_Previews: PreviewProvider {
  
  @State private static var value: Int?
  
  static var previews: some View {
    NumberTextField<Int>(title: "Placeholder Here", value: $value)
      .padding()
  }
  
}
