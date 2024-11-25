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

    func fetchTodayEvents() {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let encodedStart = isoFormatter.string(from: Date()).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let encodedEnd = isoFormatter.string(from: Date().addingTimeInterval(86400)).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else { return }

        let endpoint = "https://involved.towson.edu/api/discovery/event/search?startsAfter=\(encodedStart)&endsBefore=\(encodedEnd)"
        AF.request(endpoint).responseDecodable(of: InvolvedEvents.self) { response in
            switch response.result {
            case .success(let data):
                self.events = data.value
            case .failure(let err):
                print(err)
            }
        }
    }

    func getCoordinates(latitude: String?, longitude: String?) -> CLLocationCoordinate2D {
        if let latitude = Double(latitude ?? ""), let longitude = Double(longitude ?? "") {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        // Defaults to Union coordinates
        return CLLocationCoordinate2D(latitude: 39.394839, longitude: -76.610880)
    }

    func getImages(imgPath: String?) -> String {
        if let fullImgPath = imgPath {
            return "https://se-images.campuslabs.com/clink/images/" + fullImgPath
        }
        return ""
    }

    func getDates(dateAsString: String?) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let dateString = dateAsString,
              let date = isoFormatter.date(from: dateString)
        else { return "No date" }

        let readableFormatter = DateFormatter()
        readableFormatter.dateStyle = .medium
        readableFormatter.timeStyle = .short

        return readableFormatter.string(from: date)
    }
}
