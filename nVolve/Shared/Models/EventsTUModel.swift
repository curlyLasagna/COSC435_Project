//
//  EventsTUModel.swift
//  nVolve
//
//  Created by Luis on 12/5/24.
//

struct EventsTUEvent: Decodable, Identifiable {
    let id: Int?
    let title: String?
    let roomNum: String?
    let locationName: String?
    let description: String?
    let address: String?
    let imagePath: String?
    let geo: Geo?
    let eventInstances: [EventInstanceElement]?
    let customFields: CustomFields?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case roomNum = "room_number"
        case locationName = "location"
        case description = "description_text"
        case address
        case imagePath = "photo_url"
        case eventInstances = "event_instances"
        case geo
        case customFields = "custom_fields"
    }
}

// Dealing nested JSON in Swift had me feeling like: https://media.tenor.com/diOUKyT0TxQAAAAi/xd.gif
struct EventElement: Decodable {
    let event: EventsTUEvent
}

struct EventInstanceEventInstance: Decodable {
    let id: Int?
    let start: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case start = "start"
    }
}

struct CustomFields: Codable {
    let foodServed: String?
    let eventImageAltTextField: String?

    enum CodingKeys: String, CodingKey {
        case foodServed = "food_served"
        case eventImageAltTextField = "event_image_alt_text_field"
    }
}

struct Geo: Decodable {
    let latitude: String?
    let longitude: String?

    enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
    }
}

struct EventInstanceElement: Decodable {
    let eventInstance: EventInstanceEventInstance?

    enum CodingKeys: String, CodingKey {
        case eventInstance = "event_instance"
    }
}

struct EventsTUEvents: Decodable {
    let events: [EventElement]
    enum MyCodingKeys: String, CodingKey {
        case events
    }
}
