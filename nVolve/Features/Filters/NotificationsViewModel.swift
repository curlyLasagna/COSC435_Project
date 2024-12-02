//
//  NotificationsViewModel.swift
//  nVolve
//
//  Created by Romerico David on 11/21/24.
//

import Foundation
import UserNotifications

class NotificationsViewModel: ObservableObject {
    func checkForPermission() {
        let notificationsCenter = UNUserNotificationCenter.current()
        notificationsCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                self.dispatchNotification()
            case .denied:
                return
            case .notDetermined:
                notificationsCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, _ in
                    if success {
                        self.dispatchNotification()
                    }
                }
            default:
                return
            }
        }
    }
    
    func dispatchNotification() {
        let identifier = "test"
        let title = "Test"
        let body = "This is a test notification"
        let notificationCenter = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        // Trigger the notification after 5 seconds for testing purposes
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.add(request)
    }
}
