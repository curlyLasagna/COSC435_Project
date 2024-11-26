//
//  MapSection.swift
//  nVolve
//
//  Created by Romerico David on 11/25/24.
//

import SwiftUI
import MapKit
import CoreLocation
import CoreLocationUI

struct MapSection: View {
    @State private var position: MapCameraPosition = .automatic
    var viewModel: ContentViewModel
    var markers: Markers
    @State private var reset: Bool = false
    let manager = CLLocationManager()

    var body: some View {
        ZStack(alignment: .topLeading) {
            Map(position: $position) {
                // Static Markers
                ForEach(markers.markers, id: \.name) { marker in
                    Marker(marker.name, systemImage: marker.image, coordinate: marker.coordinate)
                        .tint(marker.color)
                }

                // Dynamic Markers
//                ForEach(viewModel.events) { event in
//                    Marker(event.eventName ?? "Event", coordinate: viewModel.getCoordinates(latitude: event.latitude, longitude: event.longitude))
//                }

                // User Location Annotation
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
                viewModel.fetchTodayEvents()
            }
            .mapStyle(.standard)
            .frame(height: 400)
            .colorScheme(.dark)

            // Reset Button
            if reset {
                Button("Reset Camera") {
                    reset = false
                }
            }
        }
    }
}
