// ContentView.swift
// nVolve
//
// Created by Abdalla Abdelmagid on 11/10/24.

import MapKit
import SwiftUI

struct ContentView: View {
    @State private var position: MapCameraPosition = .automatic
    private var contentViewModel = ContentViewModel()
    @StateObject private var viewModel = Markers()
    @StateObject private var filterViewModel = FilterViewModel()
    @State private var showEvent = false
    @State private var showingFilters = false
    @State private var reset = false
    let manager = CLLocationManager()

    var body: some View {
           ZStack {
               VStack(spacing: 0) {
                   // Filter Header Section
                   FilterHeader(showingFilters: $showingFilters)

                   // Map Section
                   ZStack(alignment: .topLeading) {
                       Map(position: $position) {
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
                   ScrollView(.horizontal, showsIndicators: true) {
                       HStack(spacing: 10) {
                           ForEach(0..<15, id: \.self) { index in
                               CardView(
                                   image: Image(systemName: "photo"),
                                   title: "Event \(index + 1)",
                                   time: "10:00 AM",
                                   room: "Room 204"
                               )
                               .onTapGesture {
                                   showEvent = true
                               }
                               .fullScreenCover(isPresented: $showEvent) {
                                   EventInfoView(
                                       showEvent: $showEvent,
                                       image: Image(systemName: "photo"),
                                       title: "Event Title",
                                       time: "10:00 AM",
                                       room: "Room 204",
                                       description: "hope this works",
                                       eventLat: 39.39069379520995,
                                       eventLng: -76.60563329053981,
                                       perks: ["free food", "arts"]
                                   )
                               }
                           }
                           ForEach(contentViewModel.events.indices, id: \.self) { index in
                               EventCard(
                                   event: contentViewModel.events[index],
                                   date: contentViewModel.getDates(dateAsString: contentViewModel.events[index].startDate),
                                   imagePath: contentViewModel.getImages(imgPath: contentViewModel.events[index].imagePath),
                                   showEvent: $showEvent
                               )
                           }
                       }
                       .background(Color.white)
                       .padding(.horizontal)
                   }
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

struct FilterHeader: View {
    @Binding var showingFilters: Bool

    var body: some View {
        HStack {
            Text(
                "Filters"
            )
            Spacer()
            Button(
                action: {
                    showingFilters.toggle()
                }) {
                    Image(
                        systemName: "slider.horizontal.3"
                    )
                }
        }
        .padding()
        .overlay(
            Rectangle()
                .stroke(
                    Color.black,
                    lineWidth: 1
                )
        )
    }
}

struct FilterOverlay: View {
    let filterViewModel: FilterViewModel
    @Binding var showingFilters: Bool

    var body: some View {
        ZStack {
            Color.black
                .opacity(
                    0.3
                )
                .ignoresSafeArea()
                .onTapGesture {
                    showingFilters = false
                }

            FilterView(
                viewModel: filterViewModel,
                dismiss: {
                    showingFilters = false
                }
            )
            .transition(
                .move(
                    edge: .trailing
                )
            )
        }
    }
}

struct MapSection: View {
    var viewModel: ContentViewModel
    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        VStack(
            spacing: 0
        ) {
            Map(
                position: $position
            ) {
                ForEach(
                    viewModel.events
                ) {
                    event in
                    Marker(
                        event.eventName ?? "boof",
                        coordinate: viewModel.getCoordinates(
                            latitude: event.latitude,
                            longitude: event.longitude
                        )
                    )
                }
            }
            .mapStyle(
                .standard
            )
            .frame(
                height: 400
            )
            .colorScheme(
                .dark
            )

            EventsHeader()
        }
    }
}

struct EventsHeader: View {
    var body: some View {
        HStack {
            Text(
                "Events"
            )
            .font(
                .title2
            )
            .fontWeight(
                .bold
            )
            .padding(
                .leading,
                16
            )
            Spacer()
        }
        .padding(
            7
        )
        .overlay(
            Rectangle()
                .stroke(
                    Color.black,
                    lineWidth: 1
                )
        )
    }
}

struct EventListSection: View {
    var viewModel: ContentViewModel
    @State private var showEvent = false

    var body: some View {
        ScrollView(
            .horizontal,
            showsIndicators: true
        ) {
            HStack(
                spacing: 10
            ) {
                ForEach(
                    viewModel.events.indices,
                    id: \.self
                ) { index in
                    EventCard(
                        event:
                            viewModel
                            .events[index],
                        date:
                            viewModel
                            .getDates(
                                dateAsString: viewModel.events[index].startDate
                            ),
                        imagePath:
                            viewModel
                            .getImages(
                                imgPath: viewModel.events[index].imagePath
                            ),
                        showEvent: $showEvent
                    )
                }
            }
            .padding(
                .horizontal
            )
        }
        .background(
            Color.gray
        )
    }
}

struct EventCard: View {
    let event: InvolvedEvent?
    let date: String
    let imagePath: String?
    @Binding var showEvent: Bool

    var body: some View {
        if let event {
            CardView(
                imagePath: imagePath,
                title: event.eventName ?? "boof",
                time: date,
                room: event.eventLocation ?? "boof"
            )
            .onTapGesture {
                showEvent = true
            }
            .fullScreenCover(
                isPresented: $showEvent
            ) {
                EventInfoView(
                    showEvent: $showEvent,
                    title: event.eventName ?? "boof",
                    time: date,
                    room: event.eventLocation ?? "boof",
                    description: event.eventDescription ?? "boof",
                    eventLat: event.latitude ?? "0.0", // Pass latitude
                    eventLng: event.longitude ?? "0.0", // Pass longitude
                    perks: event.perks ?? ["boof"]
                )
            }
        }
    }
}


#Preview {
    ContentView()
}
