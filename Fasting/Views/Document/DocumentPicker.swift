//
//  DocumentPicker.swift
//  Fasting
//
//  Created by Zach McGaughey on 8/14/21.
//

import OSLog
import SwiftUI

struct DocumentPicker: UIViewControllerRepresentable {
  
  private var onDocumentOpened: ((Data) -> Void)?
    
  func makeCoordinator() -> DocumentPickerCoordinator {
    let callback: (Data) -> Void = onDocumentOpened ?? { _ in }
    return DocumentPickerCoordinator(callback: callback)
  }
  
  func makeUIViewController(context: Context) -> some UIViewController {
    let controller = UIDocumentPickerViewController(forOpeningContentTypes: [.json], asCopy: true)
    controller.delegate = context.coordinator
    return controller
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    /* Do nothing */
  }
  
  public func onOpenDocument(perform action: @escaping (Data) -> ()) -> some View {
    var copy = self
    copy.onDocumentOpened = action
    return copy
  }
  
}

final class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate {
  
  private var callback: (Data) -> Void
  private let logger = Logger.create()
  
  init(callback: @escaping (Data) -> Void) {
    self.callback = callback
  }
  
  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    guard let fileUrl: URL = urls.first else { return }
    
    do {
      let data: Data = try Data(contentsOf: fileUrl)
      callback(data)
    
    } catch {
      logger.error("Failed to fetch file content \(error.localizedDescription, privacy: .public)")
    }
    
  }
  
}
