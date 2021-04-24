//
//  AppModel.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/20/21.
//

import Combine
import Foundation
import SwiftUI

final class AppModel: ObservableObject {
  
  static let preview: AppModel = {
    let model = AppModel(preview: true)
    model.loadDataFromStore()
    return model
  }()
  
  // MARK: - Properties
  
  /// DataManager to help persist data
  let manager: DataManager
  
  /// The currently active FastModel if it exists.
  @Published var currentFast: FastModel?
  /// Array of all completed Fasts (ie not active)
  @Published var completedFasts: [Fast] = []
  
  /// A View reference that will can be used to track a full screen context takeover
  /// For instance a date picker that presents over the current screen.
  @Published var appPresentation: AnyView?
  
  private var fastingGoalCancellable: AnyCancellable?
  
  // MARK: - Lifecycle
  
  init(preview: Bool = false) {
    
    if preview {
      manager = DataManager.preview
      
    } else {
      manager = DataManager.shared
      setupSubscriptions()
    }
    
  }
  
  /// Subscribe  to any publishers
  private func setupSubscriptions() {
    
    // When our FastingGoal changes, update any current Fast we may have
    fastingGoalCancellable = UserDefaults.standard.publisher(for: .fastingGoal)
      .compactMap { $0 }
      .compactMap(FastingGoal.init)
      .removeDuplicates()
      .dropFirst() // Drop first since we don't care about the initial value, only changes
      .sink { [weak self] (newGoal: FastingGoal) in
        self?.currentFast?.duration = newGoal.duration
      }

  }
  
}
