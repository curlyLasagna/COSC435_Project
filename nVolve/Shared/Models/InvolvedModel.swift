//
//  InvolvedModel.swift
//  nVolve
//
//  Created by Luis on 11/12/24.
//

import SwiftUICore

struct InvolvedEvent: Decodable, Identifiable {
    let id: String?
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

struct InvolvedEvents: Decodable {
    let value: [InvolvedEvent]
    enum MyCodingKeys: String, CodingKey {
        case value
    }
}
