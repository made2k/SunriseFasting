//
//  NotificationManager.swift
//  Fasting
//
//  Created by Zach McGaughey on 8/15/21.
//

import Foundation
import Logging
import OSLog
import UserNotifications

final class NotificationManager {
  
  static let shared: NotificationManager = .init()
  
  /// Static identifier for the completion notification
  private static let completionIdentifier: String = "com.notifications.completion"
  
  private let logger: Logger = .create(.application)
  
  private init() { }
  
  
  /// Request the completion notification to be delivered at a time. This function won't do anything
  /// if permission is not given to show notifications. Repeat calls to this function will cancel the previously
  /// scheduled notification.
  /// - Parameter date: The date to deliver the notification at
  func requestNotification(forDeliveryAt date: Date) {
    
    // Cancel existing notifications
    cancelNotification()
    
    Task {
      
      let center = UNUserNotificationCenter.current()
      
      let settings: UNNotificationSettings = await center.notificationSettings()
      
      switch settings.authorizationStatus {
        
      case .notDetermined:
        await requestAccess()
        requestNotification(forDeliveryAt: date)
        
      case .authorized, .provisional:
        scheduleNotification(for: date)
        
      case .denied, .ephemeral:
        fallthrough
        
      @unknown default:
        logger.debug("Unable to set notification, not authorized")
      }
      
    }
    
  }
  
  func cancelNotification() {
    
    UNUserNotificationCenter.current()
      .removePendingNotificationRequests(withIdentifiers: [Self.completionIdentifier])
    
  }
  
  func clearDelivered() {
    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
  }
  
  private func requestAccess() async {
    
    logger.debug("Requestion notification access")
    
    do {
      let granted: Bool = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .provisional])
      logger.debug("Notification access granted: \(granted)")
    } catch {
      logger.error("Error requesting notification access \(error.localizedDescription, privacy: .public)")
    }
    
  }
  
  private func scheduleNotification(for date: Date) {
    
    let content = UNMutableNotificationContent()
    content.title = "Congratulations!"
    content.body = "You've met your fasting goal!"
    content.sound = .default
    content.categoryIdentifier = FastNotificationIdentifiers.actionCategory
    if #available(iOS 15.0, *) {
      content.interruptionLevel = .timeSensitive
    }
    
    var components = DateComponents()
    components.calendar = Calendar.current
    components.month = date.month
    components.day = date.day
    components.hour = date.hour
    components.minute = date.minute
    components.second = date.second
    
    let trigger = UNCalendarNotificationTrigger(
      dateMatching: components,
      repeats: false
    )
    
    let request = UNNotificationRequest(
      identifier: Self.completionIdentifier,
      content: content,
      trigger: trigger
    )
    
    Task {
      
      let notificationCenter = UNUserNotificationCenter.current()
      do {
        try await notificationCenter.add(request)
        
      } catch {
        logger.error("Failed to add notification \(error.localizedDescription, privacy: .public)")
        return
      }
      
      let saveAction = UNNotificationAction.create(
        identifier: FastNotificationIdentifiers.saveAction,
        title: "Save and End",
        iconName: "sdcard"
      )
      let editAction = UNNotificationAction.create(
        identifier: FastNotificationIdentifiers.editAction,
        title: "Edit Fast",
        options: [.foreground],
        iconName: "pencil"
      )
      let deleteAction = UNNotificationAction.create(
        identifier: FastNotificationIdentifiers.deleteAction,
        title: "Delete Fast",
        options: [.destructive, .authenticationRequired],
        iconName: "trash"
      )
      
      let category = UNNotificationCategory(
        identifier: FastNotificationIdentifiers.actionCategory,
        actions: [saveAction, editAction, deleteAction],
        intentIdentifiers: [],
        options: []
      )
      notificationCenter.setNotificationCategories([category])
    }
  }
  
}
