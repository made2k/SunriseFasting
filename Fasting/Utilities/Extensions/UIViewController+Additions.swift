//
//  UIViewController+Additions.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/17/21.
//

import UIKit

extension UIViewController {
  
  func add(_ child: UIViewController, to view: UIView) {
    
    addChild(child)
    view.addSubview(child.view)
    child.didMove(toParent: self)
    
  }
  
  func remove() {
    
    guard parent != nil else { return }
    
    willMove(toParent: nil)
    view.removeFromSuperview()
    removeFromParent()
    
  }
  
}
