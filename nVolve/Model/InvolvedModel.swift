//
//  InvolvedModel.swift
//  nVolve
//
//  Created by Luis on 11/12/24.
//

import SwiftUICore

struct InvolvedEvents: Codable, Identifiable {
    let id: String
    let orgName: String
    let orgPhoto: String
    let eventName: String
    let eventDescription: String
    let eventLocation: String
    let startDate: Date
    let endDate: Date
    let imagePath: String
    let eventTheme: String
    let latitude: String
    let longitude: String
    let perks: [String]
    
    enum MyCodingKeys: String, CodingKey {
        case id = "id"
        case orgName = "organizationName"
        case orgPhoto = "organizationProfilePicture"
        case eventName = "name"
        case eventDescription = "description"
        case eventLocation = "location"
        case startDate = "startsOn"
        case endDate = "endsOn"
        case imagePath = "imagePath"
        case eventTheme = "theme"
        case latitude = "latitude"
        case longitude = "longitude"
        case perks = "benefitNames"
    }}
