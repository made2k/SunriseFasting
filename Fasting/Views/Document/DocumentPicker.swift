//
//  DocumentPicker.swift
//  Fasting
//
//  Created by Zach McGaughey on 8/14/21.
//

import OSLog
import SwiftUI

struct DocumentPicker: UIViewControllerRepresentable {
  
  @Binding var fileContent: String
  
  func makeCoordinator() -> DocumentPickerCoordinator {
    DocumentPickerCoordinator(fileContent: $fileContent)
  }
  
  func makeUIViewController(context: Context) -> some UIViewController {
    UIDocumentPickerViewController(forOpeningContentTypes: [.json], asCopy: true)
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    /* Do nothing */
  }
  
}

final class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate {
  
  @Binding private var fileContent: String
  private let logger = Logger.create()
  
  init(fileContent: Binding<String>) {
    _fileContent = fileContent
  }
  
  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    guard let fileUrl: URL = urls.first else { return }
    
    do {
      fileContent = try String(contentsOf: fileUrl, encoding: .utf8)
    
    } catch {
      logger.error("Failed to parse file content \(error.localizedDescription, privacy: .public)")
    }
    
  }
  
}
