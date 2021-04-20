//
//  GoalSelectionHandler.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/20/21.
//

import Foundation

/// A handler that takes a completion block with a fasting goal
typealias GoalSelectionHandler = (@escaping (FastingGoal) -> Void) -> Void
