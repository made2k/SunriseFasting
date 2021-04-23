//
//  TimerObservable.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/23/21.
//

import Combine
import Foundation

/// A class that mirrors a timer that can be observed
///
///This can be used in StateObject or ObservedObject property wrappers where a normal
///Timer cannot.
/// ~~~
///@StateObject var timer = TimerObservable(1)
/// ~~~
///
final class TimerObservable: ObservableObject, Connectable {
  
  @Published private(set) var value: Date = Date()
  
  private let timer: Timer.TimerPublisher
  
  private var sinkCancel: AnyCancellable?
  private var connectCancel: Cancellable?
  
  init(
    interval: TimeInterval,
    tolerance: TimeInterval? = nil,
    loop: RunLoop = .main,
    mode: RunLoop.Mode = .common,
    options: RunLoop.SchedulerOptions? = nil
  ) {
    
    self.timer = Timer.publish(every: interval, tolerance: tolerance, on: loop, in: mode, options: options)
    
    sinkCancel = timer.sink { [weak self] value in
      self?.value = value
    }
    
  }
  
  func connect() {
    connectCancel = timer.connect()
  }
  
  func disconnect() {
    connectCancel?.cancel()
  }
  
}
