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
        }
    }

    func getCoordinates(latitude: String?, longitude: String?) -> CLLocationCoordinate2D {
        if let latitude = Double(latitude ?? "39.394839"),
           let longitude = Double(longitude ?? "-76.610880") {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        // Default to the Union
        return CLLocationCoordinate2D(latitude: 39.394839, longitude: -76.610880)
    }

    func getStartTime(dateAsString: String?) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]
        guard let dateAsString = dateAsString,
              let createdDate = isoFormatter.date(from: dateAsString) else {
            return "No date"
        }

        let readableFormatter = DateFormatter()
        readableFormatter.dateFormat = "h:mm a"
        return readableFormatter.string(from: createdDate)
    }

    func stripHTML(text: String?) -> String {
        guard var result = text else { return "" }
        result = result.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
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
        result = result.replacingOccurrences(of: "\u{00A0}", with: " ")
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
