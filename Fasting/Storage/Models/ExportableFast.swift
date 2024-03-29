//
//  ExportableFast.swift
//  Fasting
//
//  Created by Zach McGaughey on 8/14/21.
//

import CoreData
import FastStorage
import Foundation

/// Wraps a Fast into codable allowing for easy encode/decode as well as use without
/// a managed context.
struct ExportableFast: Codable {
  
  let startDate: Date
  let endDate: Date
  let targetInterval: TimeInterval
  let mood: Int16?
  let note: String?
  
  /// Initialize an ExportableFast. ExportableFasts require a Fast with a start and end date.
  /// - Parameter fast: Fast to wrap.
  init?(_ fast: Fast) {
    guard let startDate = fast.startDate else { return nil }
    self.startDate = startDate
    
    guard let endDate = fast.endDate else { return nil }
    self.endDate = endDate
    
    self.targetInterval = fast.targetInterval
    self.mood = fast.mood
    self.note = fast.note
  }
  
}
