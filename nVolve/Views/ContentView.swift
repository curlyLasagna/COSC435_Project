//
//  ContentView.swift
//  nVolve
//
//  Created by Abdalla Abdelmagid on 11/10/24.

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var position: MapCameraPosition = .automatic
//    @StateObject private var viewModel = Markers()
    @State private var showEvent = false
    @State private var showingFilters = false
    @State var filterViewModel = FilterViewModel()
    @State var contentViewModel = ContentViewModel()
    

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    Text("Filters")
                    Spacer()
                    Button(action: {
                        showingFilters.toggle()
                    }) {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
                .padding()
                .overlay(
                    Rectangle()
                        .stroke(Color.black, lineWidth: 1)
                )

                Map(position: $position) {
//                    ForEach(viewModel.markers, id: \.name) { marker in
//                        Marker(marker.name, systemImage: marker.image, coordinate: marker.coordinate)
//                            .tint(marker.color)
//                    }
                }
                .mapStyle(.standard)
                .frame(height: 400)
                .colorScheme(.dark)
                .onTapGesture {
                    // Handle map tap if needed
                }

                HStack {
                    Text("Events")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.leading, 16)
                    Spacer()
                }
                .padding(7)
                .overlay(
                    Rectangle()
                        .stroke(Color.black, lineWidth: 1)
                )

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
                                    perks: ["free food", "arts"]
                                )
                            }
                        }
                    }
                    .background(Color.gray)
                    .padding(.horizontal)
                }
            }

            // Overlay FilterView when showingFilters is true
            if showingFilters {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showingFilters = false
                    }

                FilterView(
                    viewModel: filterViewModel,
                    dismiss: { showingFilters = false }
                )
                .transition(.move(edge: .trailing))
            }
        }
        .onAppear {
            contentViewModel.fetchTodayEvents()
        }
    }
}

#Preview {
    ContentView()
}
