//
//  ExportData.swift
//  Fasting
//
//  Created by Zach McGaughey on 8/14/21.
//

import Foundation

/// Wrapper around a URL to handle exportable data. This conforms the URL to Identifiable
struct ExportData: Identifiable {
  let id: String
  let fileUrl: URL
  
  init(_ fileUrl: URL) {
    self.id = UUID().uuidString
    self.fileUrl = fileUrl
  }
  
}
