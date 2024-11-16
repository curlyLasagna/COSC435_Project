//
//  Viewmodel.swift
//  mapkit
//
//  Created by Rasheed Nolley on 11/7/24.
//

import SwiftUI
import CoreLocation
import MapKit


class MarkerModel: ObservableObject {
    @Published var markers: [(name: String, image: String, coordinate: CLLocationCoordinate2D, color: Color)] = [
        ("Union", "building.columns.fill", .UnionLocation, Color(red: 1.0, green: 0.733, blue: 0.0)),
        ("Unitas stadium", "american.football.professional.fill", .UnitedStadium, Color(red: 1.0, green: 0.733, blue: 0.0)),
        ("Burdick hall", "dumbbell.fill", .burdick, Color(red: 1.0, green: 0.733, blue: 0.0)),
        ("Liberal arts building", "book.fill",.LibralArts, Color(red: 1.0, green: 0.733, blue: 0.0)),
        ("YR","desktopcomputer",.YR ,Color(red: 1.0, green: 0.733, blue: 0.0)),
        ("Cook library","book.pages", .Library ,Color(red: 1.0, green: 0.733, blue: 0.0)),
        ("Tu Arena","basketball.fill", .TuArena,Color(red: 1.0, green: 0.733, blue: 0.0)),
        ("Center of the Arts","paintpalette.fill", .Arts,Color(red: 1.0, green: 0.733, blue: 0.0)),
        ("Lecture Hall","pencil.line",.LectureHall ,Color(red: 1.0, green: 0.733, blue: 0.0)),
        ("Psychology Building","brain.filled.head.profile",.PsychBuilding,Color(red: 1.0, green: 0.733, blue: 0.0)),
        ("Tiger Plazza","person.wave.2",.TigerPlazza,Color(red: 1.0, green: 0.733, blue: 0.0))
        
    ]
}
