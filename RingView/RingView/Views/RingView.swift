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

public struct RingView<T>: View where T: ProgressUpdater {
  
  // ViewModel that will update the progress
  @ObservedObject var viewModel: T
  @State private var currentPercentage: Double
  
  private var backgroundColor: Color
  private var startColor: Color
  private var endColor: Color
  private var thickness: CGFloat
  private var showEmptyRing: Bool
  
  private let minValue: Double = 0.001
  
  public init(_ model: T) {
    self.viewModel = model
    
    // Initialize with default values
    _currentPercentage = State(initialValue: Self.safeMax(from: model.progress, allowZero: false))
    startColor = Color.red
    endColor = Color.orange
    backgroundColor = Color.red.opacity(0.1)
    thickness = 10
    showEmptyRing = false
  }
  
  public var body: some View {
    
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
      currentPercentage = Self.safeMax(from: progress, allowZero: showEmptyRing)
    }
  }
  
  private static func safeMax(from value: Double, allowZero: Bool) -> Double {
    if allowZero {
      return value.clamped(to: 0.0...1.999)
      
    } else {
      return value.clamped(to: 0.001...1.999)
    }
  }
  
  // MARK: Modifiers
  
  public func progress(_ value: Double) -> Self {
    let view = self
    view.currentPercentage = Self.safeMax(from: value, allowZero: showEmptyRing)
    return view
  }
  
  public func backgroundColor(_ value: Color) -> Self {
    var view = self
    view.backgroundColor = value
    return view
  }
  
  public func startColor(_ value: Color) -> Self {
    var view = self
    view.startColor = value
    return view
  }
  
  public func endColor(_ value: Color) -> Self {
    var view = self
    view.endColor = value
    return view
  }
  
  public func thickness(_ value: CGFloat) -> Self {
    var view = self
    view.thickness = value
    return view
  }
  
  public func showEmptyRing(_ value: Bool) -> Self {
    var view = self
    view.showEmptyRing = value
    return view
  }
  
}

struct RingView_Previews: PreviewProvider {
  
  @State private static var viewModel = PreviewUpdater(progress: 0.3)
  
  static var previews: some View {
    RingView(viewModel)
      .thickness(32)
      .padding()
      .onAppear {
        viewModel.connect()
      }
      .onDisappear {
        viewModel.disconnect()
      }
    
  }
  
}
