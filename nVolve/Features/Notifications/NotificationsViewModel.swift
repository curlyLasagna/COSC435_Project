//
//  NotificationsViewModel.swift
//  nVolve
//
//  Created by Romerico David on 12/6/24.
//

import Foundation
import SwiftUI
import UserNotifications

class NotificationsViewModel: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    var favoritesViewModel: FavoritesViewModel

    var favorites: [EventModel] {
        return favoritesViewModel.favoriteEvents
    }

    init(favoritesViewModel: FavoritesViewModel) {
        self.favoritesViewModel = favoritesViewModel
        super.init()
    }

    func checkForPerimssion() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                self.scheduleNotificationsForFavorites()
            case .denied:
                return
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
                    if success && error == nil {
                        self.scheduleNotificationsForFavorites()
                    } else {
                    }
                }
            default:
                return
            }
        }
    }

    func scheduleNotificationsForFavorites() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        let intervals: [TimeInterval] = [3600, 1800, 900, 300] // 1hr, 30m, 15m, 5m

        for event in favorites {
            guard let eventDate = parseEventTime(event.time) else {
                continue
            }

            for interval in intervals {
                let notificationDate = eventDate.addingTimeInterval(-interval)
                if notificationDate > Date() {
                    scheduleNotification(for: event, at: notificationDate)
                } else {
                    print("Skipping notification for \(event.id) at \(notificationDate) since it has passed")
                }
            }
        }
    }

    private func scheduleNotification(for event: EventModel, at date: Date) {
        let notificationCenter = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Event: \(event.eventName)"

        if let eventDate = parseEventTime(event.time) {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mma"
            let formattedTime = formatter.string(from: eventDate).lowercased()
            content.body = "Happening at \(formattedTime) in \(event.eventLocation)."
        } else {
            content.body = "Happening soon in \(event.eventLocation)."
        }

        content.sound = .default
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
        
        let identifier = "event-\(event.id)-\(date.timeIntervalSince1970)"

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("NotificationsViewModel: Error scheduling notification for \(event.id) - \(error.localizedDescription)")
            } else {
                print("NotificationsViewModel: Scheduled notification for \(event.id) at \(dateComponents.hour ?? 0):\(dateComponents.minute ?? 0)")
            }
        }
    }


    private func parseEventTime(_ timeString: String) -> Date? {
        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: timeString) {
            return date
        }

        return nil
    }
}
