//
//  IdleFastView.swift
//  WatchFasting Extension
//
//  Created by Zach McGaughey on 4/29/21.
//

import SwiftUI

struct IdleFastView: View {
  
  @EnvironmentObject var model: WatchDataModel
  
  var body: some View {
    
    VStack {
      
      Spacer()
      
      Text("No ongoing fasts")
        .font(.title3)
      
      Spacer()
      
      Button {
        model.sendRequestToStartFast()
        
      } label: {
        Text("Start Fast")
      }
      .disabled(model.isPending)
      
    }
    .padding()
    
  }
  
}


struct IdleFastView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      IdleFastView()
        .environmentObject(WatchDataModel.preview())
    }
  }
}
