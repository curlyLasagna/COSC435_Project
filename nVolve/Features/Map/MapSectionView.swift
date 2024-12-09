//
//  MapSection.swift
//  nVolve
//
//  Created by Romerico David on 11/25/24.
//

import CoreLocation
import CoreLocationUI
import MapKit
import SwiftUI

struct MapSection: View {
    @State private var position: MapCameraPosition = .automatic
    var viewModel: ContentViewModel
    @State private var reset: Bool = false
    let manager = CLLocationManager()
    @State private var selectedEvent: EventModel? = nil
    @State var isEventSelected: Bool = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(position: $position) {
                ForEach(viewModel.events) { event in
                    if event.building != "Narnia" {
                        Annotation(
                            event.eventName,
                            coordinate: CLLocationCoordinate2D(
                                latitude: Double(event.lat)!,
                                longitude: Double(event.long)!)
                        ) {
                            ZStack {
                                Circle()
                                    .frame(width:25 , height:25)
                                Image("tu-logo")
                                    .resizable()
                                    .frame(width:22 , height:22)
                                    .font(.title)
                                    .foregroundColor(.yellow)
                            }
                            .onTapGesture {
                                selectedEvent = event
                                isEventSelected.toggle()
                            }
                        }
                    }
                }
                UserAnnotation()
            }
            .mapControls{
                MapPitchToggle()
            }
            .onAppear {
                manager.requestWhenInUseAuthorization()
                manager.startUpdatingLocation()
            }
            .mapStyle(.standard)
            .frame(height: 410)
            .colorScheme(.dark)

            Button(action: {
                if let userLocation = manager.location {
                    position = .region(
                        MKCoordinateRegion(
                            center: userLocation.coordinate,
                            span: MKCoordinateSpan(
                                latitudeDelta: 0.01, longitudeDelta: 0.01)
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
            .padding(.trailing, 7)

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
        .sheet(
            item: $selectedEvent
        ) { event in
            // Credits to Claude because I would've never come up with whatever this is
            EventInfo(
                showEvent: Binding(
                    get: { selectedEvent != nil },
                    set: { if !$0 { selectedEvent = nil } }
                ), event: event)
        }
    }
}
