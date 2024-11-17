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
                
                // Debug statements for testing
                for event in self.events {
                    print("Event ID: \(event.id ?? "No ID")")
                    let mirror = Mirror(reflecting: event)
                    for child in mirror.children {
                        if let key = child.label {
                            print("\(key): \(child.value)")
                        }
                    }
                    print("---")
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getCoordinates() {
        
    }
    
    func getImages() {
        
    }
    
    func getDates() {
        
    }

    func fetchEventsByPerks() {

    }

    func fetchEventsByTheme() {

    }
}
