//
//  ModularSmallBuilder.swift
//  WatchFasting Extension
//
//  Created by Zach McGaughey on 4/30/21.
//

import ClockKit
import Foundation
import SwiftUI

enum ModularSmallBuilder {

  static func build(percent: Float) -> CLKComplicationTemplate {
    let imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/Modular")!)
    imageProvider.tintColor = UIColor(red: 1.0, green: 149.0/255.0, blue: 0.0, alpha: 1)

    let template = CLKComplicationTemplateModularSmallRingImage(imageProvider: imageProvider, fillFraction: percent, ringStyle: .open)
    template.tintColor = UIColor(red: 1.0, green: 204/255.0, blue: 133.0/255.0, alpha: 1)

    return template
  }

}

struct ModularSmallBuilder_Previews: PreviewProvider {

  static var previews: some View {
    Group {
      ModularSmallBuilder.build(percent: 0)
        .previewContext()

      ModularSmallBuilder.build(percent: 0.43)
        .previewContext()
    }
  }

}

