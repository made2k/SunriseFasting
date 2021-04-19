//
//  FastingTimerViewController.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/19/21.
//

import UIKit

final class FastingTimerViewController: UIViewController {
  
  static func create(_ model: FastingModel) -> FastingTimerViewController {
    let storyboard = UIStoryboard(name: "FastingTimer", bundle: nil)
    let controller = storyboard.instantiateViewController(identifier: "controller") as! FastingTimerViewController
    
    controller.model = model
    
    return controller
  }
  
  @DelayedImmutable
  private var model: FastingModel
  
  var onFastEnded: ((FastingModel) -> Void)?
  
  @IBAction private func endFastButtonPressed(_ sender: Any) {
    onFastEnded?(model)
  }
  
}
