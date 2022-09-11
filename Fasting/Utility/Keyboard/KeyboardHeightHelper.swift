//
//  KeyboardHeightHelper.swift
//  Fasting
//
//  Created by Zach McGaughey on 9/11/22.
//

import UIKit

final class KeyboardHeightHelper: ObservableObject {
  
  @Published var keyboardHeight: CGFloat = 0
  
  init() {
    self.listenForKeyboardNotifications()
  }
  
  private func listenForKeyboardNotifications() {
    NotificationCenter.default.addObserver(
      forName: UIResponder.keyboardDidShowNotification,
      object: nil,
      queue: .main
    ) { (notification: Notification) in
      guard
        let userInfo = notification.userInfo,
        let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
        return
      }
      
      self.keyboardHeight = keyboardRect.height
    }
    
    NotificationCenter.default.addObserver(
      forName: UIResponder.keyboardDidHideNotification,
      object: nil,
      queue: .main
    ) { _ in
      self.keyboardHeight = 0
    }
  }

}
