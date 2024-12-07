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
    var events: [EventModel] = []
    var dataService = DataService()

    func fetchTodayEvents() {
        Task {
            await dataService.fetchInvolved()
            await dataService.fetchTUEvents()
            self.events = dataService.events
            for e in self.events {
                print(prettyPrint(event: e))
            }
        }
    }

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
            """
    }

    func getCoordinates(latitude: String?, longitude: String?)
        -> CLLocationCoordinate2D
    {
        if let latitude = Double(latitude ?? "39.394839"),
            let longitude = Double(longitude ?? "-76.610880")
        {
            return CLLocationCoordinate2D(
                latitude: latitude, longitude: longitude)
        }
        // Default to the Union
        return CLLocationCoordinate2D(
            latitude: 39.394839, longitude: -76.610880)
    }

    func getStartTime(dateAsString: String?) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]
        guard let dateAsString = dateAsString,
            let createdDate = isoFormatter.date(from: dateAsString)
        else {
            return "No date"
        }

        let readableFormatter = DateFormatter()
        // We only care about time since we're only pulling events for today
        readableFormatter.dateFormat = "h:mm a"
        return readableFormatter.string(from: createdDate)
    }

    func stripHTML(text: String?) -> String {
        guard var result = text else { return "" }

        // Remove HTML tags using a regex
        result = result.replacingOccurrences(
            of: "<[^>]+>", with: "", options: .regularExpression)

        // Decode and remove HTML entities like &nbsp;, &amp; into plain text equivalents
        if let decodedData = result.data(using: .utf8) {
            let attributedString = try? NSAttributedString(
                data: decodedData,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue,
                ],
                documentAttributes: nil
            )
            result = attributedString?.string ?? result
        }

        // Replace non-breaking spaces
        result = result.replacingOccurrences(of: "\u{00A0}", with: " ")

        // Trim leading or trailing spaces or newlines
        result = result.trimmingCharacters(in: .whitespacesAndNewlines)

        return result
    }
}
