//
//  FastingTimerViewController.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/19/21.
//

import MKRingProgressView
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
  private var intervalTimer: Timer?
  private var usingCompletedColors: Bool?
  
  var onFastEnded: ((FastingModel) -> Void)?
  var onGoalUpdate: GoalSelectionHandler?
  
  // MARK: Outlets
  @IBOutlet private var currentGoalButton: UIButton!
  @IBOutlet private var fastStartedLabel: UILabel!
  @IBOutlet private var targetEndLabel: UILabel!
  @IBOutlet private var elapsedTimeTitleLabel: UILabel!
  @IBOutlet private var elapsedTimeLabel: UILabel!
  @IBOutlet private var progressView: RingProgressView!
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  // MARK: - Actions
  
  @IBAction private func editGoalButtonPressed(_ sender: Any) {
    
    onGoalUpdate? { [weak self] newGoal in
      
      // Update our model
      self?.model.duration = newGoal.duration
      self?.model.saveToDisk()
      
      // Update visual state
      self?.currentGoalButton.setTitle(newGoal.title, for: .normal)
      self?.updateIntervalInfo()
      self?.updateStaticInfo()
    }
    
  }
  
  @IBAction func editStartButtonPressed(_ sender: Any) {
    let controller = DatePickerViewController.create(model.startTime, maxDate: Date())

    controller.onDateSaved = { [weak self] (newDate: Date) in
      self?.model.startTime = newDate
      self?.model.saveToDisk()
      self?.updateStaticInfo()
    }
    
    present(controller, animated: true, completion: nil)
  }
  
  @IBAction private func endFastButtonPressed(_ sender: Any) {
    onFastEnded?(model)
  }
  
}

// MARK: - View Setup

extension FastingTimerViewController {
  
  private func setupView() {
    setupProgressView()
    setupObservers()
    setupFonts()
    setupUpdateInterval()
    updateStaticInfo()
  }
  
  private func setupProgressView() {
    progressView.ringWidth = 32
    progressView.backgroundRingColor = UIColor.systemGray5
    progressView.shadowOpacity = 0.25
    
    updateProgressColorsIfNeeded()
  }
  
  private func updateProgressColorsIfNeeded() {
    
    if model.progress >= 1 && usingCompletedColors != true {
      usingCompletedColors = true
      
      let completedColor = UIColor(named: "ProgressGreen")!
      
      progressView.startColor = completedColor
      progressView.endColor = completedColor
      
    } else if model.progress < 1 && usingCompletedColors != false {
      usingCompletedColors = false
      
      progressView.startColor = UIColor.systemOrange
      progressView.endColor = UIColor.systemRed
    }

  }
  
  private func setupFonts() {
    elapsedTimeTitleLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)
    elapsedTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 46, weight: .regular)
  }
  
  private func setupUpdateInterval() {
    updateIntervalInfo()
    
    intervalTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
      self?.updateIntervalInfo()
    }
    intervalTimer?.tolerance = 0.3
    
  }
  
  private func setupObservers() {
    
    NotificationCenter.default.addObserver(forName: UIApplication.significantTimeChangeNotification, object: nil, queue: .main) { [weak self] _ in
      self?.updateStaticInfo()
    }
    
  }
  
}

// MARK: - Info Setup

extension FastingTimerViewController {
  
  private func updateIntervalInfo() {
    let interval: TimeInterval = model.startTime.timeIntervalSinceNow
    elapsedTimeLabel.text = StringFormatter.interval(from: interval)
    
    let progress = abs(interval) / model.duration
    progressView.progress = progress
    
    elapsedTimeTitleLabel.text = "Elapsed time (\(StringFormatter.percent(from: progress)))"
    
    updateProgressColorsIfNeeded()
  }
  
  private func updateStaticInfo() {
    currentGoalButton.setTitle(FastingGoal.current.title, for: .normal)
    fastStartedLabel.text = StringFormatter.colloquialDateTime(from: model.startTime)
    targetEndLabel.text = StringFormatter.colloquialDateTime(from: model.targetEndTime)
  }
  
}
