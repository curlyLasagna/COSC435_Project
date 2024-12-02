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
        ZStack(alignment: .topTrailing) {
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
               
                UserAnnotation()
            }
            .mapControls{
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

          
            Button(action: {
                if let userLocation = manager.location {
                    position = .region(MKCoordinateRegion(
                        center: userLocation.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    ))
                }
                reset = true
            }) {
                Image(systemName: "location.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.blue)
            }
            .padding(10)
            .background(Color(UIColor.systemGray5))
            .clipShape(Rectangle())
            .cornerRadius(5)
            .shadow(radius: 4)
            .padding([.top], 52)
            .padding(.trailing,7)
            
                        
            // Reset Button
            if reset {
                Button("Reset Camera") {
                    reset = false
                    position = .automatic
                }
                .padding(10)
                .background(Color.black.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(15)
                .padding([.top, .leading], 100)
            }
        }
    }
}

