import MapKit
import SwiftUI

// MARK: - Main Content View
struct ContentView: View {
    private var contentViewModel = ContentViewModel()
    @StateObject private var filterViewModel = FilterViewModel()
    @State private var showingFilters = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                FilterHeader(showingFilters: $showingFilters)
                MapSection(viewModel: contentViewModel)
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
        .onAppear {
            contentViewModel.fetchTodayEvents()
        }
    }
}

struct FilterHeader: View {
    @Binding var showingFilters: Bool

    var body: some View {
        HStack {
            Text("Filters")
            Spacer()
            Button(action: { showingFilters.toggle() }) {
                Image(systemName: "slider.horizontal.3")
            }
        }
        .padding()
        .overlay(
            Rectangle()
                .stroke(Color.black, lineWidth: 1)
        )
    }
}

struct FilterOverlay: View {
    let filterViewModel: FilterViewModel
    @Binding var showingFilters: Bool

    var body: some View {
        ZStack {
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
}

struct MapSection: View {
    var viewModel: ContentViewModel
    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        VStack(spacing: 0) {
            Map(position: $position) {
                ForEach
                MapMarker(coordinate: viewModel.events)
            }
            .mapStyle(.standard)
            .frame(height: 400)
            .colorScheme(.dark)

            EventsHeader()
        }
    }
}

struct EventsHeader: View {
    var body: some View {
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
    }
}

struct EventListSection: View {
    var viewModel: ContentViewModel
    @State private var showEvent = false

    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: 10) {
                ForEach(viewModel.events.indices, id: \.self) { index in
                    EventCard(
                        event: viewModel.events[index],
                        showEvent: $showEvent
                    )
                }
            }
            .padding(.horizontal)
        }
        .background(Color.gray)
    }
}

struct EventCard: View {
    let event: InvolvedEvent?
    @Binding var showEvent: Bool

    var body: some View {
        if let event {
            CardView(
                image: Image(systemName: "photo"),
                title: event.eventName ?? "boof",
                time: event.startDate ?? "boof",
                room: event.eventLocation ?? "boof"
            )
            .onTapGesture {
                showEvent = true
            }
            .fullScreenCover(isPresented: $showEvent) {
                EventInfoView(
                    showEvent: $showEvent,
                    image: Image(systemName: "photo"),
                    title: event.eventName ?? "boof",
                    time: event.startDate ?? "boof",
                    room: event.eventLocation ?? "boof",
                    description: event.eventDescription ?? "boof",
                    perks: event.perks ?? ["boof"]
                )
            }

        }
    }
}

#Preview {
    ContentView()
}
