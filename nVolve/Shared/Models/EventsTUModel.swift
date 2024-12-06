//
//  EventsTUModel.swift
//  nVolve
//
//  Created by Luis on 12/5/24.
//

struct EventsTUEvent: Decodable, Identifiable {
    let id: String?
    let title: String?
    let roomNum: String?
    let locationName: String?
    let description: String?
    let address: String?
    let imagePath: String?
    let latitude: String?
    let longitude: String?
    let free_food: String?
    let time: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title = "title"
        case roomNum = "room_number"
        case locationName = "location"
        case description = "description_text"
        case address = "address"
        case imagePath = "photo_url"
        case latitude = "geo.latitude"
        case longitude = "geo.longitude"
        case free_food = "custom_fields.food_served"
        case time = "event.event_instances[0].event_instance.start"
    }
}

struct EventsTUEvents: Decodable {
    let events: [EventsTUEvent]
    enum MyCodingKeys: String, CodingKey {
        case events
    }
}
