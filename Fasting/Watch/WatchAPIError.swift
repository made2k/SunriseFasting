//
//  WatchAPIError.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/29/21.
//

import Foundation

enum WatchAPIError: Error {
  case invalidRequest
  case fastAlreadyActive
  case noActiveFast
}
