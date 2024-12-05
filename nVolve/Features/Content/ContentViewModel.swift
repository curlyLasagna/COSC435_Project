//
//  ContentViewModel.swift
//  nVolve
//
//  Created by Abdalla Abdelmagid on 11/11/24.
//

import Alamofire
import MapKit
import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var position: MapCameraPosition = .automatic
    @Published var showEventInfo: Bool = false
    @Published var showingFilters: Bool = false
    @Published var events: [InvolvedEvent] = []

    func fetchTodayEvents() {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]

        guard let encodedStart = isoFormatter.string(from: Date())
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let encodedEnd = isoFormatter.string(from: Date().addingTimeInterval(86400))
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else {
            return
        }

        let endpoint = "https://involved.towson.edu/api/discovery/event/search?startsAfter=\(encodedStart)&endsBefore=\(encodedEnd)"

        AF.request(endpoint).responseDecodable(of: InvolvedEvents.self) { response in
            switch response.result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.events = data.value
                }
            case .failure(let err):
                print("ContentViewModel: Error fetching events - \(err)")
            }
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

    func getImages(imgPath: String?) -> String {
        // To get the full image path, prepend the returned image path with https://se-images.campuslabs.com/clink/images/
        if let fullImgPath = imgPath {
            return "https://se-images.campuslabs.com/clink/images/" + fullImgPath
        }
        return ""
    }

    func getStartTime(dateAsString: String?) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]
        guard let dateAsString = dateAsString,
              let createdDate = isoFormatter.date(from: dateAsString) else {
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
        result = result.trimmingCharacters(in: .whitespacesAndNewlines)

        return result
    }
}
