/*
 MIT License

 Copyright (c) 2021 Exyte

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

// RingView modified by code from exyte
// repo: https://github.com/exyte/replicating

import SwiftUI

struct RingView<T>: View where T: ProgressUpdater {

  // ViewModel that will update the progress
  @ObservedObject var viewModel: T
  @State private var currentPercentage: Double
  
  private var backgroundColor: Color
  private var startColor: Color
  private var endColor: Color
  private var thickness: CGFloat

  private let minValue: Double = 0.001

  init(_ model: T) {
    self.viewModel = model

    // Initialize with default values
    _currentPercentage = State(initialValue: Self.safeMax(from: model.progress))
    startColor = .ringIncompleteStart
    endColor = .ringIncompleteEnd
    backgroundColor = Color.ringIncompleteStart.opacity(0.1)
    thickness = 10
  }
  
  var body: some View {
    
    let colors: [Color]
    // When the percentage is low, multiple colors can
    // appear clipped. If low, use only one color
    if currentPercentage > 0.1 {
      colors = [startColor, endColor]
    } else {
      colors = [startColor, startColor]
    }
    let gradient = AngularGradient(
      gradient: Gradient(colors: colors),
      center: .center,
      startAngle: Angle(degrees: 0),
      endAngle: Angle(degrees: 360 * currentPercentage)
    )
    
    return ZStack {
      RingBackgroundShape(thickness: thickness)
        .fill(backgroundColor)
      RingShape(currentPercentage: currentPercentage, thickness: thickness)
        .fill(gradient)
        .rotationEffect(.init(degrees: -90))
        .shadow(radius: 2)
        .drawingGroup()
      RingTipShape(currentPercentage: currentPercentage, thickness: thickness)
        .fill(currentPercentage > 0.5 ? endColor : .clear)
        .rotationEffect(.init(degrees: -90))
    }
    .onReceive(viewModel.progressPublisher) { progress in
      currentPercentage = Self.safeMax(from: progress)
    }
  }

  private static func safeMax(from value: Double) -> Double {
    value.clamped(to: 0.001...1.999)
  }
  
  // MARK: Modifiers
  
  func progress(_ value: Double) -> Self {
    let view = self
    view.currentPercentage = Self.safeMax(from: value)
    return view
  }
  
  func backgroundColor(_ value: Color) -> Self {
    var view = self
    view.backgroundColor = value
    return view
  }
  
  func startColor(_ value: Color) -> Self {
    var view = self
    view.startColor = value
    return view
  }
  
  func endColor(_ value: Color) -> Self {
    var view = self
    view.endColor = value
    return view
  }
  
  func thickness(_ value: CGFloat) -> Self {
    var view = self
    view.thickness = value
    return view
  }
  
}

// MARK: - Ring Shape

private struct RingShape: Shape {
  
  var currentPercentage: Double
  var thickness: CGFloat
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    path.addArc(
      center: CGPoint(x: rect.width / 2, y: rect.height / 2),
      radius: rect.width / 2 - thickness,
      startAngle: Angle(degrees: 0),
      endAngle: Angle(degrees: 360 * currentPercentage),
      clockwise: false
    )
    
    return path.strokedPath(
      .init(lineWidth: thickness, lineCap: .round, lineJoin: .round)
    )
  }
  
  var animatableData: Double {
    get { return currentPercentage }
    set { currentPercentage = newValue }
  }
  
}

// MARK: - Ring Tip Shape

private struct RingTipShape: Shape {
  
  @State var currentPercentage: Double
  @State var thickness: CGFloat
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    let angle = CGFloat((360 * currentPercentage) * .pi / 180)
    let controlRadius: CGFloat = rect.width / 2 - thickness
    let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
    let x = center.x + controlRadius * cos(angle)
    let y = center.y + controlRadius * sin(angle)
    let pointCenter = CGPoint(x: x, y: y)
    
    path.addEllipse(in:
                      CGRect(
                        x: pointCenter.x - thickness / 2,
                        y: pointCenter.y - thickness / 2,
                        width: thickness,
                        height: thickness
                      )
    )
    
    return path
  }
  
  var animatableData: Double {
    get { return currentPercentage }
    set { currentPercentage = newValue }
  }
  
}

// MARK: - Ring Background Shape

private struct RingBackgroundShape: Shape {
  
  @State var thickness: CGFloat
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.addArc(
      center: CGPoint(x: rect.width / 2, y: rect.height / 2),
      radius: rect.width / 2 - thickness,
      startAngle: Angle(degrees: 0),
      endAngle: Angle(degrees: 360),
      clockwise: false
    )
    
    return path
      .strokedPath(.init(lineWidth: thickness, lineCap: .round, lineJoin: .round))
  }
  
}


struct RingView_Previews: PreviewProvider {
  
  @State private static var viewModel = PreviewUpdater(progress: 0.3)
  
  static var previews: some View {
    RingView(viewModel)
      .thickness(32)
      .padding()
      .autoConnect(viewModel)
  }
  
}
