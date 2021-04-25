//
//  FastProgressUpdatingViewModel.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/23/21.
//

import Combine
import Foundation
import OSLog

/// ProgressUpdater that updates updates based on a provided FastModel
final class FastProgressUpdatingViewModel: ProgressUpdater {

  let logger = Logger.create(.interface)
  
  private let model: FastModel
  
  @Published private(set) var progress: Double = 0
  var progressPublished: Published<Double> { _progress }
  var progressPublisher: Published<Double>.Publisher { $progress }
  
  // We automatically trigger an update ever 5 seconds. Progress updates are
  // relatively slow over a large timeframe, so updates are not needed every second.
  private let updateTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect().prepend(Date())
  private var cancellable: AnyCancellable?
  
  // MARK: - Lifecycle
  
  init(_ model: FastModel) {
    self.model = model
  }
  
  deinit {
    disconnect()
  }
  
  // MARK: - Connections
  
  func connect() {

    logger.trace("FastProgressUpdater connected")
    
    let startDateChanged = model.$startDate.removeDuplicates()
    let durationChanged = model.$duration.removeDuplicates()
    
    cancellable = Publishers.CombineLatest3(startDateChanged, durationChanged, updateTimer)
      .map { (startDate: Date, duration: TimeInterval, _) -> Double in
        let now: Date = Date()
        let interval: TimeInterval = now.timeIntervalSince(startDate)
        let percent: Double = interval / duration
        return percent
      }
      .sink { [weak self] progress in
        self?.logger.trace("FastProgressUpdater was updated from publisher")
        self?.progress = progress
      }
    
  }
  
  func disconnect() {
    logger.trace("FastProgressUpdater disconnected")
    cancellable?.cancel()
  }
  
}
