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

internal struct RingTipShape: Shape {
  
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
    
    path.addEllipse(
      in: CGRect(
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


struct RingTipShape_Previews: PreviewProvider {
  static var previews: some View {
    RingTipShape(currentPercentage: 0.4, thickness: 15)
  }
}
