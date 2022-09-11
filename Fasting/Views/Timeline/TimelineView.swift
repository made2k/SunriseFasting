//
//  TimelineView.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/23/21.
//

import FastStorage
import Logging
import OSLog
import SwiftUI

struct TimelineView: View {

  @EnvironmentObject private var model: AppModel
  
  @State private var exportData: ExportData? = nil
  @State private var showDocumentPicker: Bool = false
    
  @State private var selection: FastModel?
  
  var body: some View {
    List {
      ForEach(FastGroup.group(model.completedFasts)) { (group: FastGroup) in
        Section(header: Text(group.title).font(.title3).fontWeight(.bold)) {
          ForEach(group.fasts) { (model: FastModel) in
            TimelineItemView(model)
              .onTapGesture {
                self.selection = model
              }
          }
        }
      }
      .onDelete { indexSet in
        Logger.viewLogger.debug("Entry deleted from timeline with: \(indexSet)")
        guard let index = indexSet.first else { return }
        let fast = model.completedFasts[index]
        model.deleteFast(fast)
      }
    }
    .listStyle(InsetGroupedListStyle())
    .navigationTitle("Timeline")
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Menu("Options") {
          Button(action: exportContent, label: {
            Label("Export", systemImage: "square.and.arrow.up")
          })
          Button(action: importContent, label: {
            Label("Import", systemImage: "square.and.arrow.down")
          })
        }
      }
    }
    .sheet(item: $exportData, onDismiss: {
      ExportManager.clearCache()
      exportData = nil
      
    }, content: { data in
      ActivityView(activityItems: [data.fileUrl], applicationActivities: nil)
    })
    .sheet(isPresented: $showDocumentPicker, onDismiss: {
      self.showDocumentPicker = false
      
    }, content: {
      DocumentPicker()
        .onOpenDocument { data in
          let manager = ExportManager(model: model)
          manager.importData(data)
        }
    })
    .sheet(item: $selection) {
      EntryEditView($0)
    }
    
  }
  
  private func exportContent() {
    let exporter = ExportManager(model: model)
    guard let fileUrl = exporter.exportDataToUrl() else { return }
    
    exportData = ExportData(fileUrl)
  }
  
  private func importContent() {
    showDocumentPicker = true
  }
  
}

struct TimelineView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      TimelineView()
        .environmentObject(AppModel.preview)
    }
  }
}
