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
    
    if let currentFast = DataManger.shared.loadCurrentFast() {
      showTimerState(currentFast)

    } else {
      showIdleState()
    }
    
  }
  
  private func showIdleState() {
    children.forEach { $0.remove() }
    
    let controller = IdleTimerViewController.create()
    controller.onFastStarted = { [weak self] in
      self?.startFast()
    }
    
    add(controller, to: view)
  }
  
  private func showTimerState(_ model: FastingModel) {
    children.forEach { $0.remove() }
    
    let controller = FastingTimerViewController.create(model)
    controller.onFastEnded = { [weak self] in
      self?.stopFast($0)
    }

    add(controller, to: view)
  }
  
  private func startFast() {
    let model = FastingModel(goal: .sixteen)
    model.saveToDisk()
    
    showTimerState(model)
  }
  
  private func stopFast(_ model: FastingModel) {
    model.endTime = Date()
    model.saveToDisk()
    
    showIdleState()
  }
  
}
