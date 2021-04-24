//
//  HomeTabView.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/23/21.
//

import SwiftUI

struct HomeTabView: View {
  var body: some View {
    TabView {
      TrackerHomeView()
        .tabItem {
          Label("Fasts", systemImage: "person.crop.circle")
        }
      NavigationView {
        TimelineView()
      }
      .tabItem {
        Label("Timeline", systemImage: "list.bullet")
      }
      
    }
  }
}

struct HomeTabView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      HomeTabView()
        .previewDevice("iPhone 8")
        .environmentObject(AppModel.preview)
      
      HomeTabView()
        .previewDevice("iPhone 12")
        .environmentObject(AppModel.preview)
      
      HomeTabView()
        .previewDevice("iPhone SE (1st generation)")
        .environmentObject(AppModel.preview)
    }
  }
}
