//
//  ContentViewModel.swift
//  Demo
//
//  Created by Abdalla Abdelmagid on 11/11/24.
//

import SwiftUI
import MapKit

class ContentViewModel: ObservableObject {
    @Published var position: MapCameraPosition = .automatic
    @Published var showingFilters: Bool = false
    
    let towsonCoordinate = CLLocationCoordinate2D(latitude: 39.3937, longitude: -76.6082)
    let filterViewModel = FilterViewModel()
}
