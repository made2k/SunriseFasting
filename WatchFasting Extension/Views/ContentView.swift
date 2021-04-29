//
//  ContentView.swift
//  WatchFasting Extension
//
//  Created by Zach McGaughey on 4/28/21.
//

import SwiftUI

struct ContentView: View {

  @EnvironmentObject var model: WatchDataModel

  var body: some View {

    switch model.currentFastData {
    case .idle:
      IdleFastView()

    case .active(let info):
      ActiveFastView(info)

    case .none:
      LoadingView()

    }

  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(WatchDataModel())
  }
}
