//
//  RingView.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/23/21.
//

import SwiftUI

struct RingView<T>: View where T: ProgressUpdater {
  
  @ObservedObject var viewModel: T
  
  @State var currentPercentage: Double
  
  @State var percentage: Double
  var backgroundColor: Color
  var startColor: Color
  var endColor: Color
  var thickness: CGFloat
  
  private let minValue: Double = 0.001
  
  var animation: Animation {
    Animation.easeInOut(duration: 1)
  }
  
  init(_ model: T) {
    self.viewModel = model
    
    _currentPercentage = State(initialValue: max(model.progress, minValue))
    _percentage = State(initialValue: model.progress)
    startColor = .ringIncompleteStart
    endColor = .ringIncompleteEnd
    backgroundColor = Color.ringIncompleteStart.opacity(0.1)
    thickness = 10
    
  }
  
  var body: some View {
    
    let colors: [Color]
    if currentPercentage > 0.1 {
      colors = [startColor, endColor]
    } else {
      colors = [startColor, startColor]
    }
    let gradient = AngularGradient(gradient: Gradient(colors: colors), center: .center, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 360 * currentPercentage))
    
    return ZStack {
      RingBackgroundShape(thickness: thickness)
        .fill(backgroundColor)
      RingShape(currentPercentage: currentPercentage, thickness: thickness)
        .fill(gradient)
        .rotationEffect(.init(degrees: -90))
        .shadow(radius: 2)
        .drawingGroup()
        .onAppear() {
          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(self.animation) {
              self.currentPercentage = self.percentage
            }
          }
        }
      RingTipShape(currentPercentage: currentPercentage, thickness: thickness)
        .fill(currentPercentage > 0.5 ? endColor : .clear)
        .rotationEffect(.init(degrees: -90))
        .onAppear() {
          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(self.animation) {
              self.currentPercentage = self.percentage
            }
          }
        }
    }.onReceive(viewModel.progressPublisher) { progress in
      currentPercentage = max(progress, minValue)
      self.percentage = max(progress, minValue)
    }
  }
  
  // Modifiers
  
  func progress(_ value: Double) -> Self {
    let view = self
    view.currentPercentage = max(value, minValue)
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

struct RingShape: Shape {
  
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
    
    return path
      .strokedPath(.init(lineWidth: thickness, lineCap: .round, lineJoin: .round))
  }
  
  var animatableData: Double {
    get { return currentPercentage }
    set { currentPercentage = newValue }
  }
  
}

struct RingTipShape: Shape {
  
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

struct RingBackgroundShape: Shape {
  
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
