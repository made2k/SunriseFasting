//
//  TimelineView.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/23/21.
//

import SwiftUI

struct TimelineView: View {
  
  @EnvironmentObject private var model: AppModel
  
  var body: some View {
    List {
      ForEach(FastGroup.group(model.completedFasts)) { (group: FastGroup) in
        Section(header: Text(group.title).font(.title3).fontWeight(.bold)) {
          ForEach(group.fasts) { (fast: Fast) in
            TimelineItemView(fast)
          }
        }
      }
      .onDelete { indexSet in
        guard let index = indexSet.first else { return }
        let fast = model.completedFasts[index]
        model.deleteFast(fast)
      }
    }
    .listStyle(InsetGroupedListStyle())
    .navigationTitle("Timeline")
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
