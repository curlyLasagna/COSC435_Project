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

}

extension InvolvedEvent {
    
    func getImages(_ imgPath: String?) -> String {
        // To get the full image path, prepend the returned image path with https://se-images.campuslabs.com/clink/images/
        if let fullImgPath = imgPath {
            return "https://se-images.campuslabs.com/clink/images/"
                + fullImgPath
        }
        return ""
    }
    
    func toEventModel() -> EventModel? {
        guard
            let id = id,
            let name = eventName,
            let description = eventDescription,
            let location = eventLocation
        else {
            return nil
        }

        return EventModel(
            id: id,
            eventName: name,
            eventDescription: description,
            eventLocation: location,
            eventImage: getImages(imagePath),
            theme: [eventTheme ?? ""],
            perks: perks ?? [],
            // Glen woods because idk where else to default
            lat: latitude ?? "39.3924982",
            long: longitude ?? "-76.6083555",
            time: startDate ?? "12:00"
        )
    }
}
