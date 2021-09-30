//
//  TimerObservable.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/23/21.
//

import Combine
import Foundation
import Logging
import OSLog

/// A class that mirrors a timer that can be observed
///
///This can be used in StateObject or ObservedObject property wrappers where a normal
///Timer cannot.
/// ~~~
///@StateObject var timer = TimerObservable(1)
/// ~~~
///
final class TimerObservable: ObservableObject, Connectable {

  let logger = Logger.create(.interface)
  
  @Published private(set) var value: Date = Date()
  
  private let interval: TimeInterval
  private let tolerance: TimeInterval?
  private let loop: RunLoop
  private let mode: RunLoop.Mode
  private let options: RunLoop.SchedulerOptions?
  
  private var timer: Timer.TimerPublisher!
  
  private var sinkCancel: AnyCancellable?
  private var connectCancel: Cancellable?
  
  init(
    interval: TimeInterval,
    tolerance: TimeInterval? = nil,
    loop: RunLoop = .main,
    mode: RunLoop.Mode = .common,
    options: RunLoop.SchedulerOptions? = nil
  ) {
    
    // We cannot create our timer here since once cancelled, it cannot
    // be restarted. So we save the values used to create it
    self.interval = interval
    self.tolerance = tolerance
    self.loop = loop
    self.mode = mode
    self.options = options
  }
  
  func connect() {

    logger.trace("TimerObservable connected")

    // Publish the current value, without this the timer will be
    // outdated by up to 1 second on reconnection.
    value = Date()
    
    // Create a new timer we subscribe to
    self.timer = Timer.publish(every: interval, tolerance: tolerance, on: loop, in: mode, options: options)
    
    sinkCancel = timer.sink { [weak self] value in
      self?.value = value
    }
    
    connectCancel = timer.connect()
  }
  
  func disconnect() {
    logger.trace("TimerObservable cancelled")
    connectCancel?.cancel()
    timer = nil
  }
  
}
