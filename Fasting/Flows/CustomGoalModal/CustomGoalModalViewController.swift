//
//  CustomGoalModalViewController.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/19/21.
//

import UIKit

class CustomGoalModalViewController: UIViewController {
  
  static func create() -> CustomGoalModalViewController {
    let storyboard = UIStoryboard(name: "CustomGoalModal", bundle: nil)
    let controller = storyboard.instantiateViewController(identifier: "controller") as! CustomGoalModalViewController
    
    return controller
  }
  
  var onIntervalSaved: ((TimeInterval) -> Void)?
  
  // MARK: Outlets
  
  @IBOutlet private var textField: UITextField!
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    textField.delegate = self
  }
  
  // MARK: - Actions
  
  @IBAction func saveButtonTapped(_ sender: Any) {
    
    guard let text = textField.text, let value = Int(text) else { return }
    
    let interval: TimeInterval = value.hours.timeInterval
    onIntervalSaved?(interval)
    
    dismiss(animated: true, completion: nil)
    
  }
  
  @IBAction func cancelButtonTapped(_ sender: Any?) {
    dismiss(animated: true, completion: nil)
  }
  
}

extension CustomGoalModalViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    if let text = textField.text, let textRange = Range(range, in: text) {
      let updatedText = text.replacingCharacters(in: textRange, with: string)
      
      if updatedText.isEmpty { return true }
      guard let hours = Int(updatedText) else { return false }
      
      return hours >= 0 && hours <= 999
      
    }
    
    return true
  }
  
}
