//
//  DurationFormatStyle.swift
//  Formatting
//
//  Created by Zach McGaughey on 9/10/22.
//

import Foundation

public extension TimeInterval {
  
  struct FormatStyle: Codable, Equatable, Hashable {
    
    public enum `Type`: Codable, Equatable, Hashable {
      case short
      case medium
      case long
    }
    
    let type: `Type`
    
    public init(_ type: `Type` = .short) {
      self.type = type
    }
    
    // MARK: Customization Method Chaining
    public func type(_ type: `Type`) -> Self {
      .init(type)
    }

  }
}

extension TimeInterval.FormatStyle: Foundation.FormatStyle {

  public func format(_ value: TimeInterval) -> String {
    switch type {
    case .short:
      return StringFormatter.countdown(from: value)
      
    case .medium:
      return StringFormatter.partialWordCountdown(from: value)
      
    case .long:
      return StringFormatter.wordCountdown(from: value)
    }
  }
  
}

// MARK: Convenience methods to access the formatted value
public extension TimeInterval {
  
  func formatted() -> String {
    Self.FormatStyle().format(self)
  }
  
  func formatted<F: Foundation.FormatStyle>(_ style: F) -> F.FormatOutput where F.FormatInput == TimeInterval {
    style.format(self)
  }
}

// MARK: Convenience FormatStyle extensions to ease access
public extension FormatStyle where Self == TimeInterval.FormatStyle {
  
  static var shortDuration: Self { .init(.short) }
  static var mediumDuration: Self { .init(.medium) }
  static var longDuration: Self { .init(.long) }
  
}
