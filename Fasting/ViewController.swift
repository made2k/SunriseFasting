//
//  ViewController.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/16/21.
//

import UIKit
import MKRingProgressView

class ViewController: UIViewController {

//  @IBOutlet var currentGoalButton: UIButton!
//
//  @IBOutlet var circleTitleLabel: UILabel!
//  @IBOutlet var circleElapsedTimeLabel: UILabel!
//  @IBOutlet var circularView: RingProgressView!
//
//  @IBOutlet var startedFastingTitleLabel: UILabel!
//  @IBOutlet var startedFastingDateLabel: UILabel!
//
//  @IBOutlet var endFastingTitleLabel: UILabel!
//  @IBOutlet var endFastingDateLabel: UILabel!
//
//  @IBOutlet var startButton: UIButton!
//
//  private var goal: FastingGoal = .sixteen
//  private var currentFast: FastingModel? {
//    didSet {
//      updateState()
//    }
//  }
//  private var updateTimer: Timer?
//
  override func viewDidLoad() {
    super.viewDidLoad()
//    setupProgressView()
//    circleElapsedTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 48, weight: .regular)
//    circleTitleLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)
//    showEmptyState()
//    loadData()
//    updateGoal()
  }
//
//  private func setupProgressView() {
//    circularView.backgroundRingColor = UIColor.systemGray6
//    circularView.startColor = UIColor.systemOrange
//    circularView.endColor = .systemRed
//    circularView.shadowOpacity = 0.34
//    circularView.hidesRingForZeroProgress = true
//    circularView.ringWidth = 36
//  }
//
//  private func updateState() {
//    switch currentFast {
//    case .none:
//      showEmptyState()
//
//    case .some(let model):
//      showFastingState(model)
//    }
//  }
//
//  private func showEmptyState() {
//    currentGoalButton.isEnabled = true
//    circularView.progress = 0
//    circleTitleLabel.text = "Not fasting"
//    circleElapsedTimeLabel.text = "--:--:--"
//    startedFastingTitleLabel.text = "START YOUR NEXT FAST"
//    startedFastingDateLabel.text = "Not Fasting"
//    endFastingTitleLabel.text = "NOT FASTING"
//    endFastingDateLabel.text = "Not Fasting"
//    startButton.setTitle("Start your fast", for: .normal)
//
//    updateTimer?.invalidate()
//  }
//
//  private func showFastingState(_ fast: FastingModel) {
//    currentGoalButton.isEnabled = false
//    startedFastingTitleLabel.text = "STARTED FASTING"
//    startedFastingDateLabel.text = formattedDate(fast.startTime)
//    endFastingTitleLabel.text = "FAST ENDING"
//    endFastingDateLabel.text = formattedDate(fast.targetEndDate)
//    startButton.setTitle("End Fast", for: .normal)
//
//    startTimer()
//  }
//
//  private func startTimer() {
//    timerUpdate()
//
//    updateTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
//      self?.timerUpdate()
//    }
//  }
//
//  private func timerUpdate() {
//    guard let fast = currentFast else { return }
//
//    let intervalSinceStart: TimeInterval = Date().timeIntervalSince(fast.startTime)
//    let progress = intervalSinceStart / fast.goal
//    circularView.progress = progress
//
//    let progressPercent: Int = Int(progress * 100)
//    circleTitleLabel.text = "Elapsed time (\(progressPercent)%)"
//    circleElapsedTimeLabel.text = formatDuration(intervalSinceStart)
//  }
//
//  private func formattedDate(_ date: Date) -> String {
//    let dateFormatter = DateFormatter()
//    dateFormatter.timeStyle = .short
//
//    return dateFormatter.string(from: date)
//  }
//
//  private func formatDuration(_ interval: TimeInterval) -> String {
//
//    let integerInterval = Int(interval)
//
//    let seconds = integerInterval % 60
//    let minutes = (integerInterval / 60) % 60
//    let hours = (integerInterval / 3600)
//
//    return String(format: "%0.2d:%0.2d:%0.2d", hours , minutes, seconds)
//  }
//
//  @IBAction func actionButtonPressed(_ sender: Any) {
//
//    if currentFast != nil {
//      currentFast = nil
//      UserDefaults.standard.removeObject(forKey: "currentFast")
//
//    } else {
//      currentFast = FastingModel(goal: goal.duration)
//      try? UserDefaults.standard.setObject(currentFast, forKey: "currentFast")
//    }
//
//  }
//
//  private func loadData() {
//    let defaults = UserDefaults.standard
//
//    self.currentFast = defaults.getObject(forKey: "currentFast")
//    self.goal = defaults.getObject(forKey: "currentGoal") ?? .sixteen
//  }
//
//  @IBAction func currentGoalButtonPressed(_ sender: Any) {
//
//    let alert = UIAlertController(title: "Change your goal", message: "Here you can set your fasting goal", preferredStyle: .actionSheet)
//
//    FastGoal.allCases.forEach { goal in
//      let action = UIAlertAction(title: goal.description, style: .default) { _ in
//        self.goal = goal
//        try? UserDefaults.standard.setObject(goal, forKey: "currentGoal")
//        self.updateGoal()
//      }
//      alert.addAction(action)
//    }
//
//    present(alert, animated: true, completion: nil)
//  }
//
//  private func updateGoal() {
//    currentGoalButton.setTitle("Current Goal: \(goal.description)", for: .normal)
//  }
  
}
