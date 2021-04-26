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

internal struct RingBackgroundShape: Shape {
  
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

struct RingBackgroundShape_Previews: PreviewProvider {
    static var previews: some View {
        RingBackgroundShape(thickness: 15)
    }
}
