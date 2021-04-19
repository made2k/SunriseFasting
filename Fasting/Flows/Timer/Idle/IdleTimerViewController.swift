//
//  IdleTimerViewController.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/19/21.
//

import UIKit

final class IdleTimerViewController: UIViewController {
  
  static func create() -> IdleTimerViewController {
    let storyboard = UIStoryboard(name: "IdleTimerViewController", bundle: nil)
    let controller = storyboard.instantiateViewController(identifier: "controller") as! IdleTimerViewController
    return controller
  }
  
  var onFastStarted: (() -> Void)?
    
  @IBAction private func startFastButtonPressed(_ sender: Any) {
    onFastStarted?()
  }
  
}
