//
//  PaddedButton.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/19/21.
//

import UIKit

class PaddedButton: UIButton {
  
  override var frame: CGRect {
    didSet {
      roundCorners()
    }
  }
    
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  private func setup() {
    contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
  }
  
  private func roundCorners() {
    let smallestSize: CGFloat = min(frame.size.width, frame.size.height)
    layer.cornerRadius = smallestSize / 2
  }
    
}

// MARK: - Touches

extension PaddedButton {
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    
    UIView.animate(withDuration: 0.1) {
      self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
    }
    
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    
    UIView.animate(withDuration: 0.1) {
      self.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    
  }
  
}
