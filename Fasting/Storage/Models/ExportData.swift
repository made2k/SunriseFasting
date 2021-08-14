//
//  ExportData.swift
//  Fasting
//
//  Created by Zach McGaughey on 8/14/21.
//

import Foundation

struct ExportData: Identifiable{
  let id: String
  let fileUrl: URL
  
  init(_ fileUrl: URL) {
    self.id = fileUrl.absoluteString
    self.fileUrl = fileUrl
  }
  
}
