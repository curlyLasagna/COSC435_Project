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
    var events: [InvolvedEvent] = []
    // ':' is encoded as %3
    // 'T' is the separator between time and date
    func fetchTodayEvents() {
        // This function is only for involved @ TU. A refactor will be required to accodomate other data sources
        let encodedStart = ISO8601DateFormatter().string(from: Date())
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        let encodedEnd = ISO8601DateFormatter().string(
            from: Date().advanced(by: 86400)
        ).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        let endpoint =
            "https://involved.towson.edu/api/discovery/event/search? startsAfter=\(encodedStart!)endsBefore=\(encodedEnd!)"
        AF.request(endpoint).responseDecodable(of: InvolvedEvents.self) {
            response in
            switch response.result {
            case .success(let data):
                self.events = data.value
            case .failure(let err):
                print(err)
            }
        }
    }

    func getCoordinates(latitude: String?, longitude: String?)
        -> CLLocationCoordinate2D
    {
        if let latitude = Double(latitude ?? "39.394839"),
            let longitude = Double(longitude ?? "76.610880")
        {
            return CLLocationCoordinate2D(
                latitude: Double(latitude), longitude: Double(longitude))
        }
        // Default to the Union
        return CLLocationCoordinate2D(latitude: 39.394839, longitude: 76.610880)
    }

    func getImages(imgPath: String?) -> String {
        // To get the full image path, prepend the returned image path with https://se-images.campuslabs.com/clink/images/
        if let fullImgPath = imgPath {
            return "https://se-images.campuslabs.com/clink/images/"
                + fullImgPath
        }
        return ""
    }

    func getStartTime(dateAsString: String?) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [
            .withInternetDateTime
        ]
        guard let dateAsString = dateAsString else {
            return "No date"
        }

        guard let createdDate = isoFormatter.date(from: dateAsString) else {
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
        result = result.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        
        // Decode and remove HTML entities like &nbsp;, &amp; into plain text equivalents
        if let decodedData = result.data(using: .utf8) {
            let attributedString = try? NSAttributedString(
                data: decodedData,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            result = attributedString?.string ?? result
        }
        
        // Replace non-breaking spaces
        result = result.replacingOccurrences(of: "\u{00A0}", with: " ")
        
        // Trim leading or trailing spaces or newlines
        result = result.trimmingCharacters(in: .whitespaces)
        
        return result
    }


    func fetchEventsByPerks() {

    }

    func fetchEventsByTheme() {

    }
}
