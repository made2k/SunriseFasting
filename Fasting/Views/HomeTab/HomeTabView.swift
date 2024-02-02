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
          Label {
            Text("Fasts", comment: "Fast tab title")
          } icon: {
            Image(systemName: "person.crop.circle")
          }
        }
      NavigationView {
        TimelineView()
      }
      .tabItem {
        Label {
          Text("Timeline", comment: "Timeline tab title")
        } icon: {
          Image(systemName: "list.bullet")
        }
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
