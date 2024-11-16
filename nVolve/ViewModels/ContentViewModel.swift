//
//  ContentViewModel.swift
//  nVolve
//
//  Created by Abdalla Abdelmagid on 11/11/24.
//

import SwiftUI
import MapKit

class ContentViewModel: ObservableObject {
    @Published var position: MapCameraPosition = .automatic
    @Published var showEventInfo: Bool = false
    @Published var showingFilters: Bool = false
}
