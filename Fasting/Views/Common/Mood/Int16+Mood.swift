//
//  Int16+Mood.swift
//  Fasting
//
//  Created by Zach McGaughey on 2/28/22.
//

import Foundation

extension Int16 {

  var moodEmoji: String? {
    switch self {
    case 1:
      return "😫"

    case 2:
      return "🙁"

    case 3:
      return "😐"

    case 4:
      return "🙂"

    case 5:
      return "😀"

    default:
      return nil

    }
  }

}
