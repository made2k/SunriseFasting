//
//  ProgressUpdater.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/21/21.
//

import Combine

public protocol ProgressUpdater: ObservableObject { //Connectable, ObservableObject {
  
  var progress: Double { get }
  var progressPublished: Published<Double> { get }
  var progressPublisher: Published<Double>.Publisher { get }

}
