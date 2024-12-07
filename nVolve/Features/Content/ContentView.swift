//
//  ContentView.swift
//  nVolve
//
//  Created by Abdalla Abdelmagid on 11/10/24.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @State var contentViewModel = ContentViewModel()
    @State private var position: MapCameraPosition = .automatic
    @StateObject private var viewModel = Markers()
    @StateObject private var filterViewModel = FilterViewModel()
    
    @State private var showingFilters = false
    
    @StateObject var favoritesViewModel = FavoritesViewModel()
    @StateObject var notificationsViewModel: NotificationsViewModel

    init() {
        let fvm = FavoritesViewModel()
        _favoritesViewModel = StateObject(wrappedValue: fvm)
        _notificationsViewModel = StateObject(wrappedValue: NotificationsViewModel(favoritesViewModel: fvm))
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // App Header
                ZStack {
                    // Centered Logo
                    Image("tu-involved")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 60)
                        .onTapGesture {
                            position = .automatic
                        }

                    // Right-Aligned Filter Header
                    HStack {
                        Spacer()
                        FilterHeader(showingFilters: $showingFilters)
                    }
                }
                .padding(.bottom)



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
        .onChange(of: contentViewModel.events.map(\.id)) {
            favoritesViewModel.allEvents = contentViewModel.events
        }
        .onAppear {
            contentViewModel.fetchTodayEvents()
            notificationsViewModel.checkForPerimssion()
        }
    }
}
