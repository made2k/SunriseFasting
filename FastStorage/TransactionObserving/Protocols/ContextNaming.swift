//
//  ContextNaming.swift
//  FastStorage
//
//  Created by Zach McGaughey on 9/28/21.
//

import Foundation

protocol ContextNaming {
  var tranactionAuthor: String { get }
  var contextName: String? { get }
}
