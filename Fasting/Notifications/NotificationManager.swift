//
//  NotificationManager.swift
//  Fasting
//
//  Created by Zach McGaughey on 8/15/21.
//

import Foundation
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
    
    let center = UNUserNotificationCenter.current()
    center.getNotificationSettings { [weak self] (settings: UNNotificationSettings) in
      
      if settings.authorizationStatus == .notDetermined {
        self?.requestAccess {
          self?.requestNotification(forDeliveryAt: date)
        }
        
        return
      }
      
      guard settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional else {
        self?.logger.debug("Unable to set notification, not authorized")
        return
      }
      
      self?.scheduleNotification(for: date)
      
    }

  }
  
  func cancelNotification() {
    
    UNUserNotificationCenter.current()
      .removePendingNotificationRequests(withIdentifiers: [Self.completionIdentifier])
    
  }
  
  func clearDelivered() {
    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
  }
  
  private func requestAccess(completion: @escaping () -> Void) {
    
    logger.debug("Requestion notification access")
    
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .provisional]) { [weak self] granted, error in
      guard granted else {
        self?.logger.debug("Notification access not grated")
        return
      }
      
      if let error = error {
        self?.logger.error("Error requesting notification access \(error.localizedDescription, privacy: .public)")
        return
      }
      
      completion()
    }
    
  }
  
  private func scheduleNotification(for date: Date) {
    
    let content = UNMutableNotificationContent()
    content.title = "Congratulations!"
    content.body = "You've met your fasting goal!"
    content.sound = .default
    
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
    
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.add(request) { [weak self] error in
      
      if let error = error {
        self?.logger.error("Failed to add notification \(error.localizedDescription, privacy: .public)")
      }
      
    }
    
  }
  
}
