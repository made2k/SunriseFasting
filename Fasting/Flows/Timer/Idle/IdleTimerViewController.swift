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
    
    controller.lastFast = DataManger.shared.loadLastCompletedFast()
    
    return controller
  }
  
  var onFastStarted: (() -> Void)?
  
  @DelayedImmutable
  private var lastFast: FastingModel?
  private var intervalTimer: Timer?
  private var clockTimer: Timer?
  private var completionTimer: Timer?
  
  @IBOutlet var lastFastTitleLabel: UILabel!
  @IBOutlet var lastFastIntervalLabel: UILabel!
  @IBOutlet var upcomingFastEndLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    
    if let lastFast = lastFast {
      setupLastFastTimer(lastFast)
      
    } else {
      showNewUserState()
    }
    
  }
    
  @IBAction private func startFastButtonPressed(_ sender: Any) {
    onFastStarted?()
  }
  
}

// MARK: - View Setup

extension IdleTimerViewController {
  
  private func setupView() {
    setupFonts()
    setupCompletionUpdated()
  }
  
  private func setupFonts() {
    lastFastIntervalLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 46, weight: .regular)
  }
  
  private func setupLastFastTimer(_ model: FastingModel) {
    
    updateIntervalInfo(model)
    
    intervalTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
      self?.updateIntervalInfo(model)
    }
    intervalTimer?.tolerance = 0.3
    
  }

  
  private func setupCompletionUpdated() {
    updateCompletionInfo()

    // Completion is based on time from now. We want to update in "real time"
    // so we need to synchronize our updates with the clock. Wait for the minute
    // to change, then schedule our updates every minute after that.
    let delay: Int = 60 - Date().second

    clockTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(delay), repeats: false) { [weak self] _ in
      
      self?.updateCompletionInfo()
      
      self?.completionTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
        self?.updateCompletionInfo()
      }
      
      self?.completionTimer?.tolerance = 1
      self?.clockTimer = nil
    }
  }
  
}

// MARK: - View States {

extension IdleTimerViewController {
  
  private func showNewUserState() {
    lastFastTitleLabel.isHidden = true
    lastFastIntervalLabel.text = "Start your first fast!"
  }
  
  private func updateIntervalInfo(_ model: FastingModel) {
    lastFastTitleLabel.isHidden = false

    guard let interval = model.endTime?.timeIntervalSinceNow else { return }
    let string = StringFormatter.interval(from: interval)
    lastFastIntervalLabel.text = string
  }

  private func updateCompletionInfo() {
    let targetEnd: Date = Date().dateByAdding(16, .hour).date
    upcomingFastEndLabel.text = StringFormatter.colloquialDateTime(from: targetEnd)
  }
  
}
