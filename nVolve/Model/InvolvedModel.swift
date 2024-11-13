//
//  InvolvedModel.swift
//  nVolve
//
//  Created by Luis on 11/12/24.
//

import SwiftUICore

struct Involved: Codable, Identifiable {
    let id: String
    let orgName: String
    let orgPhoto: Image
    let eventName: String
    let eventDescription: String
    let eventLocation: String
    let startDate: Date
    let endDate: Date
    let imagePath: Image
    let eventTheme: String
    let latitude: String
    let longitude: String
    
    enum MyCodingKeys: String, CodingKey {
        case id = "id"
        
    }}
