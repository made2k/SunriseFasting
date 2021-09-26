//
//  NotificationHandler.swift
//  Fasting
//
//  Created by Zach McGaughey on 9/26/21.
//

import Foundation
import OSLog
import UserNotifications
import SwiftUI

class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
  
  static let shared: NotificationHandler = .init()
  
  private let logger: Logger = .create(.application)
  private weak var model: AppModel?
  
  // MARK: - Initialization
  
  private override init() {  }
  
  /// Register this handler to receive notifications actions with a given AppModel to run
  /// the actions on.
  /// - Parameter model: The AppModel that actions will be run on.
  func register(with model: AppModel) {
    self.model = model
    UNUserNotificationCenter.current().delegate = self
  }
  
  // MARK: - Actions
  
  private func saveFast(_ model: AppModel) {
    guard let currentFast = model.currentFast else { return }
    model.endFast(currentFast, endDate: Date())
  }
  
  private func editFast(_ model: AppModel) {
    guard let currentFast = model.currentFast else { return }
    
    let now: Date = .init()
    
    let presentationBinding = Binding(
      get: {
        model.appPresentation
      },
      set: {
        model.appPresentation = $0
      }
    )

    var picker = DatePickerSelectionView(
      date: .constant(now),
      minDate: currentFast.startDate,
      maxDate: now,
      presented: presentationBinding,
      animate: true
    )
    picker.onDateSelected = {
      model.endFast(currentFast, endDate: $0)
    }
    
    model.appPresentation = AnyView(picker)
  }
  
  private func deleteFast(_ model: AppModel) {
    guard let currentFast = model.currentFast else { return }
    model.deleteFast(currentFast)
  }
  
  // MARK: - Notification Center Delegate
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    guard let model = model else { return }
    
    guard response.notification.request.content.categoryIdentifier == FastNotificationIdentifiers.actionCategory else {
      logger.warning("Received notification action with unexpected category identifier")
      return
    }
    
    switch response.actionIdentifier {
    case FastNotificationIdentifiers.saveAction:
      saveFast(model)
      
    case FastNotificationIdentifiers.editAction:
      editFast(model)
      
    case FastNotificationIdentifiers.deleteAction:
      deleteFast(model)
      
    default:
      logger.warning("Unknown notificatio action identifier \(response.actionIdentifier)")
    }
    
    completionHandler()
  }
  
}
