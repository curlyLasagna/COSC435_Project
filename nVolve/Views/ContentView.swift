import MapKit
import SwiftUI

struct ContentView: View {
    private var contentViewModel = ContentViewModel()
    @StateObject private var filterViewModel = FilterViewModel()
    @State private var showingFilters = false
    @StateObject private var locationManager = LocationManager()

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
        .onChange(of: contentViewModel.events) { oldEvents, newEvents in
            locationManager.updateEvents(newEvents)
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
                ForEach(viewModel.events) {
                    event in
                    Marker(event.eventName ?? "boof", coordinate: viewModel.getCoordinates(latitude: event.latitude, longitude: event.longitude))
                }
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
    @State private var selectedEvent: InvolvedEvent?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: 10) {
                ForEach(viewModel.events.indices, id: \.self) { index in
                    let event = viewModel.events[index]
                    EventCard(
                        event: event,
                        date: viewModel.getDates(dateAsString: event.startDate),
                        imagePath: viewModel.getImages(imgPath: event.imagePath),
                        showEvent: $showEvent,
                        selectedEvent: $selectedEvent
                    )
                }
            }
            .padding(.horizontal)
        }
        .background(Color.gray)
        .sheet(isPresented: $showEvent) {
            if let event = selectedEvent {
                EventInfoView(
                    showEvent: $showEvent,
                    event: event
                )
            }
        }
    }
}

struct EventCard: View {
    let event: InvolvedEvent
    let date: String
    let imagePath: String?
    @Binding var showEvent: Bool
    @Binding var selectedEvent: InvolvedEvent?

    var body: some View {
        CardView(
            imagePath: imagePath,
            title: event.eventName ?? "No Title",
            time: date,
            room: event.eventLocation ?? "No Location"
        )
        .onTapGesture {
            selectedEvent = event
            showEvent = true
        }
    }
}

#Preview {
    ContentView()
}
