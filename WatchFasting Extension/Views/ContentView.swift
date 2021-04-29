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
    
    ZStack {
      
      switch model.currentDataState {
      
      case .uninitialized:
        LoadingView()
        
      case .idlePending, .idle:
        IdleFastView()
      
      case .activePending:
        ActiveFastView(nil)
        
      case .active(fastInfo: let fastInfo):
        ActiveFastView(fastInfo)
        
      case .savingData(fastInfo: let fastInfo, endDate: let endDate):
        SaveFastView(fastInfo, stopDate: endDate)
        
      }
      
    }
    
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(WatchDataModel())
  }
}
