//
//  WatchWidgetEntry.swift
//  FastingWidgetExtension
//
//  Created by Zach McGaughey on 4/26/21.
//

import Foundation
import SharedDataWatch
import WidgetKit

struct WatchWidgetEntry: TimelineEntry {
  let date: Date
  let data: SharedWidgetDataType
}
