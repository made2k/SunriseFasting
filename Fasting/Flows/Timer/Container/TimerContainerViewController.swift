//
//  TimerContainerViewController.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/17/21.
//

import UIKit

final class TimerContainerViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    loadCurrentState()
  }
  
  private func loadCurrentState() {
    
    if let _: FastingModel = UserDefaults.standard.getObject(forKey: "currentFast") {
      
      let storyboard = UIStoryboard(name: "FastingTimer", bundle: nil)
      let controller = storyboard.instantiateViewController(identifier: "controller")

      add(controller, to: view)
      
    } else {
      
      let storyboard = UIStoryboard(name: "IdleTimerViewController", bundle: nil)
      let controller = storyboard.instantiateViewController(identifier: "controller")
      
      add(controller, to: view)
      
    }
    
    
  }
  
}
