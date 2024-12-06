//
//  InvolvedModel.swift
//  nVolve
//
//  Created by Luis on 11/12/24.
//

import SwiftUI

struct InvolvedEvent: Decodable, Encodable, Identifiable, Equatable {
    let id: String
    let orgName: String?
    let orgPhoto: String?
    let eventName: String?
    let eventDescription: String?
    let eventLocation: String?
    let startDate: String?
    let endDate: String?
    let imagePath: String?
    let eventTheme: String?
    let latitude: String?
    let longitude: String?
    let perks: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case orgName = "organizationName"
        case orgPhoto = "organizationProfilePicture"
        case eventName = "name"
        case eventDescription = "description"
        case eventLocation = "location"
        case startDate = "startsOn"
        case endDate = "endsOn"
        case imagePath = "imagePath"
        case eventTheme = "theme"
        case latitude
        case longitude
        case perks = "benefitNames"
    }
}

struct InvolvedEvents: Decodable, Encodable {
    let value: [InvolvedEvent]
}

extension InvolvedEvent {
    var startDateParsed: Date? {
        guard let startDate = startDate else { return nil }
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: startDate)
    }
}
