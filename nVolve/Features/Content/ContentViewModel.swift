//
//  ContentViewModel.swift
//  nVolve
//
//  Created by Abdalla Abdelmagid on 11/11/24.
//

import Alamofire
import MapKit
import SwiftUI

@Observable class ContentViewModel {
    var position: MapCameraPosition = .automatic
    var showEventInfo: Bool = false
    var showingFilters: Bool = false
    var events: [EventModel] = []          // Original array
    var filteredEvents: [EventModel] = []  // Array for displaying filtered results
    var dataService = DataService()

    func fetchTodayEvents() {
        Task {
            await dataService.fetchInvolved()
            await dataService.fetchTUEvents()
            self.events = dataService.events
            self.filteredEvents = dataService.events // Initialize filteredEvents
            for e in self.events {
                print(prettyPrint(event: e))
            }
        }
    }

    // Debugging purposes
    func prettyPrint(event: EventModel) -> String {
        let formattedThemes =
            event.theme.isEmpty ? "None" : event.theme.joined(separator: ", ")
        let formattedPerks =
            event.perks.isEmpty ? "None" : event.perks.joined(separator: ", ")

        return """
            Event Details:
            --------------
            Name: \(event.eventName)
            Description: \(event.eventDescription.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil))
            Location: \(event.eventLocation)
            Image URL: \(event.eventImage)
            Themes: \(formattedThemes)
            Perks: \(formattedPerks)
            Latitude: \(event.lat)
            Longitude: \(event.long)
            Time: \(event.time)
            Building: \(event.building)
            """
    }

}
