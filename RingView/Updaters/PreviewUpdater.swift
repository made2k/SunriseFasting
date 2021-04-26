//
//  PreviewUpdater.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/23/21.
//

import Combine
import Foundation

/// A ProgressUpdater meant for use in previews. It advances to 100% ever 10 seconds
internal final class PreviewUpdater: ProgressUpdater {
  
  @Published var progress: Double = 0
  var progressPublished: Published<Double> { _progress }
  var progressPublisher: Published<Double>.Publisher { $progress }
  
  private var cancellable: AnyCancellable?
  
  init(progress: Double) {
    self.progress = progress
  }
  
  func connect() {

    cancellable = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
      .scan(progress) { (value: Double, _) -> Double in
        value + 0.1
      }
      .map { (value: Double) -> Double in
        value.truncatingRemainder(dividingBy: 1)
      }
      .sink { [weak self] in
        self?.progress = $0
      }
    
  }
  
  func disconnect() {
    cancellable?.cancel()
  }
  
}
