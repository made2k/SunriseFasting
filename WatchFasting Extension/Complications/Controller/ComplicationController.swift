//
//  ComplicationController.swift
//  WatchFasting Extension
//
//  Created by Zach McGaughey on 4/28/21.
//

import ClockKit
import SharedDataWatch
import SwiftUI

class ComplicationController: NSObject, CLKComplicationDataSource, CLKComplicationWidgetMigrator {
  
  private let dataModel = WatchDataModel.shared
  private var cachedType: SharedWidgetDataType?
  
  @available(watchOS 9.0, *)
  var widgetMigrator: CLKComplicationWidgetMigrator {
    return self
  }

  // MARK: - Data Loading

  /// Attempt to load data from our companion app and use that data for our complications.
  /// - Parameter handler: Handler that activates when data is fetched.
  private func loadIfNeeded(_ handler: @escaping (SharedWidgetDataType) -> Void) {

    // First attempt to load cached values
    switch dataModel.interfaceState {
    case .active(let info):
      self.cachedType = .active(fastInfo: info)
      
    case .idle:
      self.cachedType = .idle(lastFastDate: nil)
      
    default:
      break
    }
    
    if let value = cachedType {
      handler(value)
      
    } else {
      // If we don't have data already, hook in to our data model for a refresh.
      dataModel.complicationHooks.append { [weak self] data in
        self?.cachedType = data
        handler(data)
      }
      // Make the call to refresh our data
      dataModel.refreshDataFromApp()
    }
    
  }

  // MARK: - Complication Configuration

  func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {

    let supportedFamilies: [CLKComplicationFamily] = [
      .circularSmall,
      .modularSmall,
      .utilitarianSmall,
      .graphicCorner,
      .graphicCircular,
      .graphicExtraLarge
    ]

    let descriptors = [
      CLKComplicationDescriptor(
        identifier: "complication",
        displayName: "Fasting",
        supportedFamilies: supportedFamilies
      )
    ]

    // Call the handler with the currently supported complication descriptors
    handler(descriptors)
  }

  func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
    // Do any necessary work to support these newly shared complication descriptors
  }

  // MARK: - Timeline Configuration

  // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
  func getTimelineEndDate(
    for complication: CLKComplication,
    withHandler handler: @escaping (Date?) -> Void
  ) {

    loadIfNeeded { data in
      
      switch data {
      case .idle:
        // If we're inactive, we don't have any data to really display
        // and thus no end timeline
        handler(nil)
        
      case .active(let info):
        // Provide the final date that we hit 100% of our fast, no more updates after that.
        handler(info.targetEndDate)
      }
      
    }
    
  }

  // Call the handler with your desired behavior when the device is locked
  func getPrivacyBehavior(
    for complication: CLKComplication,
    withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void
  ) {

    // Fasting data can be considered personal, don't display on lock screen.
    handler(.hideOnLockScreen)

  }

  // MARK: - Timeline Population

  // Call the handler with the current timeline entry
  func getCurrentTimelineEntry(
    for complication: CLKComplication,
    withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void
  ) {

    loadIfNeeded { data in

      let entryDate: Date = self.getCurrentTimelineDate(data: data)
      let optionalTemplate = ComplicationTemplateFactory.makeTemplate(for: entryDate, with: data, complication: complication)

      // If we don't have a template, fail early
      guard let template = optionalTemplate else {
        return handler(nil)
      }

      let entry = CLKComplicationTimelineEntry(date: entryDate, complicationTemplate: template)
      handler(entry)
      
    }
    
  }

  func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
    // Call the handler with the timeline entries after the given date

    loadIfNeeded { data in

      switch data {
      case .idle:
        // Idle state only needs one entry since we never update while idle.
        guard let template = ComplicationTemplateFactory
                .makeTemplate(
                  for: date,
                  with: data,
                  complication: complication
                ) else {

          return handler(nil)
        }

        let entry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
        return handler([entry])

      case .active(let info):

        // If our complication doesn't support multiple timelines, just
        // make and return one entity.
        if self.supportsIncrementingTimelines(family: complication.family) == false {
          let entries = self.getNonUpdatingTimelines(for: date, data: data, complication: complication)
          return handler(entries)
        }
        
        // Generate our list of entities.

        // Add 1 offset since we're getting the next entry after the date.
        var current: Date = self.getCurrentTimelineDate(from: date, data: data, offset: 1)
        var entries: [CLKComplicationTimelineEntry] = []

        while current < info.targetEndDate && entries.count < limit {
          
          if let template = ComplicationTemplateFactory
              .makeTemplate(for: current, with: data, complication: complication) {

            let entry = CLKComplicationTimelineEntry(date: current, complicationTemplate: template)
            entries.append(entry)
          }

          // The next interval is 1% away, use the time for percent to advance
          // to the next entry
          let updateInterval = info.targetInterval / 100.0
          current = current.addingTimeInterval(updateInterval)
        }
        
        return handler(entries)
      }
      
    }
    
  }

  // MARK: - Sample Templates

  func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
    // This method will be called once per supported complication, and the results will be cached
    handler(nil)
  }
  
  // MARK: - WidgetKit Migration
  
  @available(watchOS 9.0, *)
  func widgetConfiguration(from complicationDescriptor: CLKComplicationDescriptor) async -> CLKComplicationWidgetMigrationConfiguration? {
    CLKComplicationStaticWidgetMigrationConfiguration(
      kind: "FastingWatchWidget",
      extensionBundleIdentifier: "com.zachmcgaughey.Fasting.watchkitapp.FastingWatchWidget"
    )
  }

  // MARK: - Helpers

  /// We calculate timelines by dates from percentages of the completed fast.
  /// Due to this, we cannot use our current date as the current entry since we
  /// may now be off by a period of time when updating to the next percent. This
  /// function calculated the current timeline entry date.
  /// - Parameters:
  ///   - data: Data used to provide date info.
  ///   - offset: A percent offset to be applied to the calculation. Useful for finding next or previous dates.
  /// - Returns: A date of the current entry based on the current system time.
  private func getCurrentTimelineDate(from date: Date = Date(), data: SharedWidgetDataType, offset: Int = 0) -> Date {

    switch data {
    case .idle:
      // If not current fast, we can just return the current time.
      return date

    case .active(let info):
      let now: Date = date

      // Get the total time that 1% takes
      let percentInterval: TimeInterval = info.targetInterval / 100.0
      // Get the current percent so we can calculate what time to set
      let currentProgress: Double = min(now.timeIntervalSince(info.startDate) / info.targetInterval, 1.0)
      // This is our current percent from 0-100
      let currentTick: Int = max(min(Int(100 * currentProgress) + offset, 100), 0)

      // By adding the time interval of currentTick * percentInterval to the start date,
      // it gives us the date that our current entry would start at.
      let targetInterval: TimeInterval = TimeInterval(currentTick) * percentInterval
      let tickDate: Date = info.startDate.addingTimeInterval(targetInterval)
      return tickDate
    }

  }

  /// Helper function to tell if a complication family supports incrementing timeline entities.
  /// - Parameter family: The family to check.
  /// - Returns: Returns true if the family supports multiple timeline entries, false otherwise.
  private func supportsIncrementingTimelines(family: CLKComplicationFamily) -> Bool {

    // These families use time based gauges and have no need
    // to update multiple times.
    let unsupportedFamilies: [CLKComplicationFamily] = [
      .graphicCorner,
      .graphicExtraLarge,
      .graphicCircular
    ]

    return unsupportedFamilies.contains(family) == false

  }

  /// This function will attempt to fetch the Timeline Entries for the provided date, and one more for the end.
  /// Since this is not granting a continuously updating set of entries, only current and final are provided.
  /// - Parameters:
  ///   - date: Date the entries should be provided after
  ///   - data: The data to build the templates
  ///   - complication: The complication to build the templates.
  /// - Returns: Returns an optional array of entries.
  private func getNonUpdatingTimelines(
    for date: Date,
    data: SharedWidgetDataType,
    complication: CLKComplication
  ) -> [CLKComplicationTimelineEntry]? {

    // We need to generate at least one to be able to continue, if we can't create
    // this, we cannot continue.
    guard let currentTemplate = ComplicationTemplateFactory
            .makeTemplate(
              for: date,
              with: data,
              complication: complication
            ) else {
      return nil
    }

    let currentEntry = CLKComplicationTimelineEntry(date: date, complicationTemplate: currentTemplate)

    switch data {
    case .idle:
      // Idle needs no other updates. Just a single entry
      return [currentEntry]

    case .active(let info):
      // If the date is already after the target end date, just provide one single entry
      if date > info.targetEndDate {
        return [currentEntry]
      }

      // We need to generate the ending entry
      guard let endTemplate = ComplicationTemplateFactory
              .makeTemplate(
                for: info.targetEndDate,
                with: data,
                complication: complication
              ) else {
        return [currentEntry]
      }
      let endEntry = CLKComplicationTimelineEntry(date: info.targetEndDate, complicationTemplate: endTemplate)
      return [currentEntry, endEntry]

    }

  }

}
