//
//  LargeComplicationIdle.swift
//  WatchFasting Extension
//
//  Created by Zach McGaughey on 4/30/21.
//

import ClockKit
import SwiftUI
import WatchKit

struct LargeComplicationIdle: View {
    var body: some View {
      VStack {
        Text("Delete")
        
      }
    }
}

struct LargeComplicationIdle_Previews: PreviewProvider {
    static var previews: some View {
      
      CLKComplicationTemplateGraphicExtraLargeCircularView(LargeComplicationIdle())
        .previewContext()
//        LargeComplicationIdle()
    }
}
