//
//  DataService.swift
//  nVolve
//
//  Created by Luis on 11/24/24.
//
import Alamofire
import MapKit
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

    func fetchTUEvents() async {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let eventDate = dateFormatter.string(from: Date())
        let endpoint =
            "https://events.towson.edu/api/2/events/?start=\(eventDate)"

        await withCheckedContinuation { continuation in
            AF.request(endpoint).responseDecodable(of: EventsTUEvents.self) {
                response in
                switch response.result {
                case .success(let data):
                    self.events.append(
                        contentsOf: data.events.filter({
                            $0.event.experience == "inperson"
                        }).compactMap { $0.event.toEventModel() })
                case .failure(let err):
                    print(err)
                }
                continuation.resume()
            }
        }

    }
}

// Since the data doesn't want to play nice, this is the least amount of effort I can put in that would categorize events by building
// Not exactly the most accurate but good enough for an MVP
func setBuildingByCoordinates(lat: Double, long: Double) -> String {
    // How close a coordinate has to be
    let threshold: Double = 400.0

    let buildingLocations: [String: CLLocation] = [
        "Union": CLLocation(
            latitude: 39.39329226884807, longitude: -76.61096268644614),
        "Liberal Arts": CLLocation(
            latitude: 39.39492842913834, longitude: -76.60932724025416),
        "Burdick": CLLocation(
            latitude: 39.395271855922246, longitude: -76.61218288627627),
        "York Road": CLLocation(
            latitude: 39.39069379520995, longitude: -76.60563329053981),
        "Arts": CLLocation(
            latitude: 39.3913806226192, longitude: -76.61289412243788),
        "NewmanCenter": CLLocation(
            latitude: 39.39192875071915, longitude: -76.60394030346345),
        "TuArena": CLLocation(
            latitude: 39.387711752091846, longitude: -76.61701109977116),
        "TigerPlazza": CLLocation(
            latitude: 39.39506413482851, longitude: -76.61081088812264),
        "Library": CLLocation(
            latitude: 39.39409061261545, longitude: -76.60649108812262),
        "WestVillageDining": CLLocation(
            latitude: 39.39390693537731, longitude: -76.61816013552868),
        "Narnia": CLLocation(
            latitude: 39.3924982, longitude: -76.6083555),
        "LectureHall": CLLocation(latitude: 39.394018, longitude: -76.608473),
        "UnitedStadium": CLLocation(latitude: 39.388695, longitude: -76.616015),
        "PsychBuilding": CLLocation(
            latitude: 39.394597029100346, longitude: -76.60900408836083),
    ]

    let eventLocation = CLLocation(latitude: lat, longitude: long)
    let closestBuilding = buildingLocations.min {
        eventLocation.distance(from: $0.value)
            < eventLocation.distance(from: $1.value)
    }

    if let closestBuilding = closestBuilding,
        eventLocation.distance(from: closestBuilding.value) <= threshold
    {
        return closestBuilding.key
    }
    return "Narnia"

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

        return EventModel(
            id: id,
            eventName: name,
            eventDescription: description,
            eventLocation: location,
            eventImage: getImages(imagePath),
            theme: [eventTheme ?? ""],
            perks: perks ?? [],
            lat: latitude ?? "39.3924982",
            long: longitude ?? "-76.6083555",
            time: time,
            building: setBuildingByCoordinates(
                lat: Double(latitude ?? "39.3924982")!,
                long: Double(longitude ?? "-76.6083555")!)
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
            let time = eventInstances?.first?.eventInstance?.start
        else {
            return nil
        }

        return EventModel(
            id: String(id),
            eventName: name,
            eventDescription: description,
            eventLocation: location,
            eventImage: imagePath ?? "",
            theme: [""],
            perks: customFields?.foodServed == "Yes" ? ["Free Food"] : [],
            lat: geo?.latitude ?? "39.3924982",
            long: geo?.longitude ?? "-76.6083555",
            time: time,
            // 🤮
            building: setBuildingByCoordinates(
                lat: Double(geo?.latitude ?? "39.3924982")!,
                long: Double(geo?.longitude ?? "-76.6083555")!)

        )
    }
}
