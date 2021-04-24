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
      HomeScreenView()
        .tabItem {
          Image(systemName: "person.crop.circle")
          Text("Fasts")
        }
      NavigationView {
        TimelineView()
      }
      .tabItem {
        Image(systemName: "list.bullet")
        Text("Timeline")
      }
      
    }
  }
}

struct HomeTabView_Previews: PreviewProvider {
  static var previews: some View {
    HomeTabView()
      .environmentObject(AppModel.preview)
  }
}
