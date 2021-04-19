//
//  DelayedImmutable.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/19/21.
//

import Foundation

@propertyWrapper
struct DelayedImmutable<Value> {
  private var _value: Value?

  init() {
    _value = nil
  }
  
  var wrappedValue: Value {
    get {
      guard let value = _value else {
        preconditionFailure("property accessed before being initialized")
      }
      return value
    }
    
    // Perform an initialization, trapping if the
    // value is already initialized.
    set {
      if _value != nil {
        preconditionFailure("property initialized twice")
      }
      _value = newValue
    }
  }
}
