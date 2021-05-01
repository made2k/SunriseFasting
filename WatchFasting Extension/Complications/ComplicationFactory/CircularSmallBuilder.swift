//
//  CircularSmallBuilder.swift
//  WatchFasting Extension
//
//  Created by Zach McGaughey on 4/30/21.
//

import ClockKit
import Foundation
import SwiftUI

enum CircularSmallBuilder {

  static func build(percent: Float) -> CLKComplicationTemplate {
    let imageProvider = CLKImageProvider(
      onePieceImage: UIImage(named: "Complication/Circular")!
    )

    return CLKComplicationTemplateCircularSmallRingImage(
      imageProvider: imageProvider,
      fillFraction: percent,
      ringStyle: .open
    )
  }

}

//struct CircularSmallBuilder_Previews: PreviewProvider {
//
//  private static let previewRange: ClosedRange<Date> =
//    Date().addingTimeInterval(-60)...Date().addingTimeInterval(60)
//
//  static var previews: some View {
//    Group {
//      CircularSmallBuilder.build(percent: 0)
//        .previewContext()
//
//      CircularSmallBuilder.build(percent: 0.43)
//        .previewContext()
//    }
//  }
//
//}
