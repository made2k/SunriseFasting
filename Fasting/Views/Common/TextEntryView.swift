//
//  TextEntryView.swift
//  Fasting
//
//  Created by Zach McGaughey on 9/11/22.
//

import UIKit
import SwiftUI

struct TextEntryView: UIViewRepresentable {
  @Binding var text: String?
  @Binding var textStyle: UIFont.TextStyle
  
  var backgroundColor: UIColor = .clear
  
  func makeUIView(context: Context) -> UITextView {
    let textView = UITextView()
    
    textView.delegate = context.coordinator
    textView.backgroundColor = backgroundColor
    textView.font = UIFont.preferredFont(forTextStyle: textStyle)
    textView.autocapitalizationType = .sentences
    textView.isSelectable = true
    textView.isUserInteractionEnabled = true
    
    return textView
  }
  
  func updateUIView(_ uiView: UITextView, context: Context) {
    uiView.text = text
    uiView.backgroundColor = backgroundColor
    uiView.font = UIFont.preferredFont(forTextStyle: textStyle)
  }
  
  // MARK: - Modifiers
  
  func backgroundColor(_ value: UIColor) -> Self {
    var view = self
    view.backgroundColor = value
    return view
  }

  
  // MARK: - Coordinator
  
  func makeCoordinator() -> Coordinator {
    Coordinator($text)
  }
  
  class Coordinator: NSObject, UITextViewDelegate {
    var text: Binding<String?>
    
    init(_ text: Binding<String?>) {
      self.text = text
    }
    
    func textViewDidChange(_ textView: UITextView) {
      self.text.wrappedValue = textView.text
    }
  }
  
}


struct TextEntryView_Previews: PreviewProvider {
  
  static var previews: some View {
    TextEntryView(text: .constant("Text Goes here!"), textStyle: .constant(.body))
      .padding()
  }
  
}
