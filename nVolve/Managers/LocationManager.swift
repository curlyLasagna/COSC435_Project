//
//  LocationManager.swift
//  nVolve
//
//  Created by Romerico David on 11/25/24.
//

import Foundation
import CoreLocation
import UserNotifications

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation?
    var events: [InvolvedEvent] = []
    var notifiedEventIDs: Set<String> = []

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestLocationPermission()
        requestNotificationPermission()
    }

    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }

    func updateEvents(_ events: [InvolvedEvent]) {
        self.events = events
        notifiedEventIDs.removeAll()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        checkProximityToEvents()
    }

    func checkProximityToEvents() {
        guard let userLocation = currentLocation else { return }
        for event in events {
            guard
                let eventLatitude = Double(event.latitude ?? ""),
                let eventLongitude = Double(event.longitude ?? ""),
                let eventID = event.id
            else { continue }

            let eventLocation = CLLocation(latitude: eventLatitude, longitude: eventLongitude)
            let distance = userLocation.distance(from: eventLocation)

            if distance <= 1000 {
                if !notifiedEventIDs.contains(eventID) {
                    NotificationsManager.shared.scheduleNotification(for: event)
                    notifiedEventIDs.insert(eventID)
                }
            } else {
                notifiedEventIDs.remove(eventID)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}
