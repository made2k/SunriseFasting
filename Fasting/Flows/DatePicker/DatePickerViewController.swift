//
//  DatePickerViewController.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/19/21.
//

import UIKit

class DatePickerViewController: UIViewController {
  
  static func create(_ date: Date, minDate: Date? = nil, maxDate: Date? = nil) -> DatePickerViewController {
    let storyboard = UIStoryboard(name: "DatePicker", bundle: nil)
    let controller = storyboard.instantiateViewController(identifier: "controller") as! DatePickerViewController
    
    controller.loadViewIfNeeded()
    controller.datePicker.date = date
    controller.datePicker.minimumDate = minDate
    controller.datePicker.maximumDate = maxDate
    
    return controller
  }
  
  var onDateSaved: ((Date) -> Void)?
  
  // MARK: Outlets

  @IBOutlet private var backgroundView: UIView!
  @IBOutlet private var datePicker: UIDatePicker!
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
        
    let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(backgroundWasTapped))
    backgroundView.addGestureRecognizer(tapToDismiss)
  }
  
  // MARK: - Actions
  
  @IBAction func saveButtonTapped(_ sender: Any) {
    onDateSaved?(datePicker.date)
    dismiss(animated: true, completion: nil)
  }
  
  @objc
  private func backgroundWasTapped() {
    cancelButtonTapped(nil)
  }
  
  @IBAction func cancelButtonTapped(_ sender: Any?) {
    dismiss(animated: true, completion: nil)
  }
  
}
