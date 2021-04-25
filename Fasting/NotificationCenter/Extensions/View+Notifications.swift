//
//  View+Notifications.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/25/21.
//

import Foundation
import SwiftUI

extension View {

  func onNotification(
    _ notificationName: Notification.Name,
    perform action: @escaping () -> Void
  ) -> some View {

    onReceive(NotificationCenter.default.publisher(for: notificationName)) { _ in
      action()
    }

  }
}
