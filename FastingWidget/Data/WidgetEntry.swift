//
//  WidgetEntry.swift
//  FastingWidgetExtension
//
//  Created by Zach McGaughey on 4/26/21.
//

import Foundation
import SharedData
import WidgetKit

struct WidgetEntry: TimelineEntry {
  let date: Date
  let relevance: TimelineEntryRelevance?
  let data: SharedWidgetDataType
}
