//
//  NotificationsManager.swift
//  nVolve
//
//  Created by Romerico David on 11/25/24.
//

import Foundation
import UserNotifications

class NotificationsManager {
    static let shared = NotificationsManager()

    private init() {
        requestNotificationPermission()
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }

    func scheduleNotification(for event: InvolvedEvent) {
        guard
            let eventID = event.id,
            let eventName = event.eventName,
            let startDateString = event.startDate,
            let startDate = parseDate(from: startDateString)
        else { return }

        let content = UNMutableNotificationContent()
        content.title = "Upcoming Event: \(eventName)"
        content.body = "Your subscribed event is about to start."
        content.sound = .default

        let triggerDateComponents = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: startDate
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)

        let request = UNNotificationRequest(
            identifier: "subscribed_\(eventID)",
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Scheduling error: \(error.localizedDescription)")
            }
        }
    }

    func cancelNotification(for event: InvolvedEvent) {
        if let eventID = event.id {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["subscribed_\(eventID)"])
        }
    }

    private func parseDate(from dateString: String) -> Date? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return isoFormatter.date(from: dateString)
    }
}
