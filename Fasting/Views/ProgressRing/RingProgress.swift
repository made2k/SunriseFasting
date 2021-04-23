//
//  RingProgress.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/21/21.
//

import MKRingProgressView
import SwiftUI

struct RingProgress<T>: View where T: ProgressUpdater {
  
  @ObservedObject var viewModel: T
  
  var body: RingProgressViewWrapper {
    RingProgressViewWrapper()
      .progress(viewModel.progress)
  }
    
}

struct RingProgressViewWrapper: UIViewRepresentable {
  
  typealias UIViewType = RingProgressView
    
  private var startColor: UIColor = UIColor(named: "RingIncompleteStart") ?? UIColor.red
  private var endColor: UIColor = UIColor(named: "RingIncompleteEnd") ?? UIColor.blue
  private var backgroundRingColor: UIColor? = UIColor(named: "RingIncompleteStart")?.withAlphaComponent(0.1)
  private var ringWidth: CGFloat = 10
  private var shadowOpacity: CGFloat = 0.3
  private var progress: Double = 0
    
  func makeUIView(context: Context) -> RingProgressView {
    let view = RingProgressView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    // To improve performance set these values. Helps create this view quicker
    view.gradientImageScale = 0.1
    view.allowsAntialiasing = false
    return view
  }

  func updateUIView(_ view: RingProgressView, context: Context) {
    view.startColor = startColor
    view.endColor = endColor
    view.ringWidth = ringWidth
    view.backgroundRingColor = backgroundRingColor
    view.shadowOpacity = shadowOpacity
    
    // For performance on especially large values, only show up to 200%
    if progress > 1 {
      view.progress = 1 + progress.truncatingRemainder(dividingBy: 1)
    } else {
      view.progress = progress
    }
  }
  
  func startColor(_ value: UIColor) -> Self {
    var view = self
    view.startColor = value
    return view
  }

  func endColor(_ value: UIColor) -> Self {
    var view = self
    view.endColor = value
    return view
  }

  func backgroundRingColor(_ value: UIColor?) -> Self {
    var view = self
    view.backgroundRingColor = value
    return view
  }

  func ringWidth(_ value: CGFloat) -> Self {
    var view = self
    view.ringWidth = value
    return view
  }
  
  func shadowOpacity(_ value: CGFloat) -> Self {
    var view = self
    view.shadowOpacity = value
    return view
  }
  
  func progress(_ value: Double) -> Self {
    var view = self
    view.progress = value
    return view
  }

}

struct RingProgress_Previews: PreviewProvider {
  
  @State private static var viewModel = PreviewUpdater(progress: 0.3)
  
  static var previews: some View {
    RingProgress(viewModel: viewModel)
      .body
      .progress(0.67)
      .ringWidth(32)
      .autoConnect(viewModel)
  }
}
