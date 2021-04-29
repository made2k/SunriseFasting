//
//  LoadingView.swift
//  WatchFasting Extension
//
//  Created by Zach McGaughey on 4/29/21.
//

import SwiftUI

struct LoadingView: View {

  @State private var isLoading = false

  var body: some View {
    
    ZStack {
      Circle()
        .stroke(Color(UIColor.gray), lineWidth: 8)
        .frame(maxWidth: 100, maxHeight: 100)
      Circle()
        .trim(from: 0, to: 0.2)
        .stroke(Color.orange, lineWidth: 7)
        .frame(maxWidth: 100, maxHeight: 100)
        .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
        .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
        .onAppear() {
          self.isLoading = true
        }
    }
    
  }
  
}

struct LoadingView_Previews: PreviewProvider {
  static var previews: some View {
    LoadingView()
  }
}
