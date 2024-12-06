//
//  DataService.swift
//  nVolve
//
//  Created by Luis on 11/24/24.
//
import Alamofire
import SwiftUI

@Observable class DataService {

    var events: [EventModel] = []

    func fetchInvolved() async {
        // This function is only for involved @ TU. A refactor will be required to accodomate other data sources
        let encodedStart = ISO8601DateFormatter().string(from: Date())
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        let encodedEnd = ISO8601DateFormatter().string(
            from: Date().advanced(by: 86400)
        ).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        let endpoint =
            "https://involved.towson.edu/api/discovery/event/search? startsAfter=\(encodedStart!)endsBefore=\(encodedEnd!)"
        await withCheckedContinuation { continuation in
            AF.request(endpoint).responseDecodable(of: InvolvedEvents.self) {
                response in
                switch response.result {
                case .success(let data):
                    self.events.append(
                        contentsOf: data.value.compactMap { $0.toEventModel() })
                case .failure(let err):
                    print(err)
                }
                continuation.resume()
            }
        }
    }

    private func fetchEvents() async {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let eventDate = dateFormatter.string(from: Date())
        let endpoint = "https://events.towson.edu/api/2/events/?start=\(eventDate)&end\(eventDate)"
        
        await withCheckedContinuation { continuation in
            AF.request(endpoint).responseDecodable(of: EventsTUEvent.self) {
                response in
                switch response.result {
                case .success(let data):
                    print(data)
//                    self.events.append(
//                        contentsOf: data.value.compactMap() { $0.toEventModel()}
//                    )
                case .failure(let err):
                    print(err)
                }
                continuation.resume()
            }
        }
        
    }
}

extension InvolvedEvent {
    func toEventModel() -> EventModel? {
        // Discard events that have nil values for these attributes
        guard
            let id = id,
            let name = eventName,
            let description = eventDescription,
            let location = eventLocation,
            let time = startDate
        else {
            return nil
        }

        //        let dateFormatter = ISO8601DateFormatter()
        //        guard let startDate = dateFormatter.date(from: startDateString) else {
        //            return nil
        //        }

        return EventModel(
            id: id,
            eventName: name,
            eventDescription: description,
            eventLocation: location,
            eventImage: imagePath ?? "",
            theme: [eventTheme ?? ""],
            perks: perks ?? [],
            lat: latitude ?? "39.3924982",
            long: longitude ?? "-76.6083555",
            time: time
        )
    }
}

extension EventsTUEvent {
    func toEventModel() -> EventModel? {
        guard
            let id = id,
            let name = title,
            let description = description,
            let location = locationName,
            let time = time,
            let lat = latitude,
            let long = longitude else {
            return nil
        }
        
        return EventModel(id: id, eventName: name, eventDescription: description, eventLocation: location, eventImage: <#T##String#>, theme: <#T##[String]#>, perks: <#T##[String]#>, lat: <#T##String#>, long: <#T##String#>, time: <#T##String#>)
    }
}
