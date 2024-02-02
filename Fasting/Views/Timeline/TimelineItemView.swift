//
//  TimelineItemView.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/23/21.
//

import FastStorage
import Formatting
import RingView
import SwiftUI

struct TimelineItemView: View {
  
  @ObservedObject var model: FastModel
  
  init(_ model: FastModel) {
    self.model = model
  }
  
  var body: some View {
    
    VStack {
      HStack(spacing: 24) {
        RingView(ConstantUpdater(model.entity.progress))
          .thickness(8)
          .applyProgressiveStyle(model.entity.progress)
          .frame(width: 64, height: 64, alignment: .center)
        VStack(alignment: .leading) {
          Text(model.startDate.formatted(date: .abbreviated, time: .omitted))
            .foregroundColor(Color(.secondaryLabel))
          Text(model.progress.formatted(.percentRounded))
          Text("\(Self.roundedHours(from: model.entity.currentInterval))/\(Self.roundedHours(from: model.entity.targetInterval))h")
        }
        
        Spacer()
        
      }
      
      HStack {
        
        Text(
          "\(Self.string(from: model.startDate)) - \(Self.string(from: model.endDate))",
          comment: "Presenting a date range"
        )
        .lineLimit(1)
        
        Spacer()
        
        if let mood = model.mood, mood > 0 {
          Text(
            "Mood: \(mood.moodEmoji ?? "?")",
            comment: "Describes the current mode with an emoji as the value"
          )
        }
        
        if model.note.isNilOrEmpty == false {
          Image(systemName: "note.text")
        }
        
      }
      .font(.footnote)
      .foregroundColor(.secondary)
    }
    .cornerRadius(8)
    
  }
  
  /// Format a TimeInterval into a short hour description (ie 16h)
  /// - Parameter interval: The TimeInterval to use for formatting
  /// - Returns: A string formatted like 16h
  private static func roundedHours(from interval: TimeInterval) -> String {
    let hours: TimeInterval = interval / 3600
    
    let formatter = NumberFormatter()
    formatter.roundingMode = .halfUp
    formatter.maximumFractionDigits = 1
    
    return formatter.string(from: NSNumber(value: hours)) ?? "0"
  }
  
  private static func string(from date: Date?) -> String {
    guard let date = date else { return "??" }
    return date.formatted(date: .omitted, time: .shortened)
  }
  
}

struct TimelineItemView_Previews: PreviewProvider {
  static var previews: some View {
    
    VStack {
      TimelineItemView(FastModel.preview)
        .frame(maxHeight: 120)
      
      TimelineItemView(FastModel.preview)
        .frame(maxHeight: 72)
    }
    
  }
}

