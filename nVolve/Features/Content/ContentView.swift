//
//  ContentView.swift
//  nVolve
//
//  Created by Abdalla Abdelmagid on 11/10/24.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @StateObject var favoritesViewModel = FavoritesViewModel()
    @ObservedObject var contentViewModel = ContentViewModel()
    @State private var position: MapCameraPosition = .automatic
    @StateObject private var viewModel = Markers()
    @StateObject private var filterViewModel = FilterViewModel()
    @State private var showingFilters = false

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
                MapSection(
                    viewModel: contentViewModel,
                    markers: viewModel
                )

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
        .environmentObject(favoritesViewModel)
        .onReceive(contentViewModel.$events) { events in
            favoritesViewModel.allEvents = events
        }
        .onAppear {
            contentViewModel.fetchTodayEvents()
        }
    }
}
