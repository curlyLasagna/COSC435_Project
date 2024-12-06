//
//  NotificationsViewModel.swift
//  nVolve
//
//  Created by Romerico David on 12/6/24.
//

import Foundation
import UserNotifications

class NotificationsViewModel: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    /**
     * Procedure:
     * Get favorites
     * For each favorites, send a notification for each favorited event 1hr, 30m, 15m, and 5m away from it
     * NOTE: This only sends a local push notification. It does not do remote push notifications or interact with Apple Push Notification Service because we don't have an Apple Developer account.
     *
     */
    
    func checkForPerimssion() {
        let notificatoinCenter = UNUserNotificationCenter.current()
        notificatoinCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                print("Success")
                self.dispatchNotification()
                
            case .denied:
                print("Error")
                return
            case .notDetermined:
                print("In Progress")
                notificatoinCenter.requestAuthorization(options: [.alert]) { success, _ in
                    if success {
                        print("Success")
                        self.dispatchNotification()
                    }
                }
            default:
                return
            }
        
        }
        
    }
    
    // This only dispatches it when the app isn't open
    func dispatchNotification() {
        let identifier = "my-morning-notification"
        let title = "Time to party 🎉"
        let body = "💃🕺💃🕺💃🕺"
        let hour = 15 // Adjust this to test
        let minute = 38 // Adjust this to test
        
        let isDaily = true
        
        let notificationCenter = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let calendar = Calendar.current
        var dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier]) // Removes all pending notification
        notificationCenter.add(request) // Adds it to the queue
        
    }
}
