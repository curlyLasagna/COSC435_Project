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
                
//                // Debug statements for testing
//                for event in self.events {
//                    print("Event ID: \(event.id ?? "No ID")")
//                    let mirror = Mirror(reflecting: event)
//                    for child in mirror.children {
//                        if let key = child.label {
//                            print("\(key): \(child.value)")
//                        }
//                    }
//                    print("---")
//                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getCoordinates(latitude: String?, longitude: String?) -> CLLocationCoordinate2D {
        // Convert string into
        if let latitude = Double(latitude ?? "39.394839"), let longitude = Double(longitude ?? "76.610880") {
            return CLLocationCoordinate2D(latitude: Double(latitude), longitude: Double(longitude))
        }
        // Defaults to Union
        return CLLocationCoordinate2D(latitude: 39.394839, longitude: 76.610880)
    }
    
    func getImages(imgPath: String?) -> String {
        // To get the full image path, prepend the returned image path with https://se-images.campuslabs.com/clink/images/
        if let fullImgPath = imgPath {
            return  "https://se-images.campuslabs.com/clink/images/" + fullImgPath
        }
        return ""
    }
    
    func getDates(dateAsString: String?) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [
            .withFullDate,
//            .withTime,
        ]
       
        guard let createdDate = isoFormatter.date(from: dateAsString ?? "Boof") else {
                  return "No date"
              }
//        let readableFormatter = DateFormatter()
//        readableFormatter.dateStyle = .medium
//        readableFormatter.timeStyle = .short
        
        return DateFormatter().string(from: createdDate)
    }

    func fetchEventsByPerks() {

    }

    func fetchEventsByTheme() {

    }
}
