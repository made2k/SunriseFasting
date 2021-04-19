//
//  TimerContainerViewController.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/17/21.
//

import Hero
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
  
}

// MARK: - Parent Actions

extension TimerContainerViewController {
  
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

// MARK: - Children Management

extension TimerContainerViewController {
  
  private func showIdleState() {
    
    let controller = IdleTimerViewController.create()
    controller.onFastStarted = { [weak self] in
      self?.startFast()
    }
    
    transition(children.first, new: controller)
    
  }
  
  private func showTimerState(_ model: FastingModel) {
    
    let controller = FastingTimerViewController.create(model)
    controller.onFastEnded = { [weak self] in
      self?.stopFast($0)
    }
    
    transition(children.first, new: controller)
    
  }
  
  private func transition(_ old: UIViewController?, new: UIViewController) {
    
    guard let old = old else {
      add(new, to: view)
      return
    }
    
    Hero.shared.transition(from: old, to: new, in: view) { [weak self] _ in
      guard let self = self else { return }
      
      old.remove()
      self.add(new, to: self.view)
    }
    
  }
  
}
