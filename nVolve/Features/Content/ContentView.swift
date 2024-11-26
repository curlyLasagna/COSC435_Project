// ContentView.swift
// nVolve
//
// Created by Abdalla Abdelmagid on 11/10/24.

import MapKit
import SwiftUI
import CoreLocation
import CoreLocationUI

struct ContentView: View {
    @State private var position: MapCameraPosition = .automatic
    private var contentViewModel = ContentViewModel()
    @StateObject private var viewModel = Markers()
    @StateObject private var filterViewModel = FilterViewModel()
    @State private var showingFilters = false
    @State private var reset = false
    let manager = CLLocationManager()

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // App Header
                HStack {
                    Spacer()
                    Image("tu-involved")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 40)
                        .onTapGesture {
                            position = .automatic
                        }
                    Spacer()
                }

                // Filter Header Section
                FilterHeader(showingFilters: $showingFilters)

                // Map Section
                ZStack(alignment: .topLeading) {
                    Map(position: $position) {
                        // Add Markers for static and dynamic events
                        ForEach(viewModel.markers, id: \.name) { marker in
                            Marker(marker.name, systemImage: marker.image, coordinate: marker.coordinate)
                                .tint(marker.color)
                        }
                        ForEach(contentViewModel.events) { event in
                            Marker(event.eventName ?? "Event", coordinate: contentViewModel.getCoordinates(latitude: event.latitude, longitude: event.longitude))
                        }
                        UserAnnotation()
                    }
                    .mapControls {
                        MapUserLocationButton().onTapGesture {
                            reset = true
                        }
                        MapPitchToggle()
                    }
                    .onAppear {
                        manager.requestWhenInUseAuthorization()
                        manager.startUpdatingLocation()
                        contentViewModel.fetchTodayEvents()
                    }
                    .mapStyle(.standard)
                    .frame(height: 400)
                    .colorScheme(.dark)

                    if reset {
                        Button("Reset Camera") {
                            reset = false
                        }
                    }
                }

                // Events Header
                EventsHeader()

                // Event List Section
                EventListSection(viewModel: contentViewModel)
            }

            // Overlay Filter View
            if showingFilters {
                FilterOverlay(
                    filterViewModel: filterViewModel,
                    showingFilters: $showingFilters
                )
            }
        }
    }
}
