import SwiftUI
import MapKit

struct EventInfo: View {
    @Binding var showEvent: Bool
    var imagePath: String?
    var title: String
    var time: String
    var room: String
    var description: String
    @State private var favorited: Bool // This state tracks whether the event is favorited

    // Placeholder data
    var eventLat: String
    var eventLng: String
    var perks: [String]

    init(showEvent: Binding<Bool>, imagePath: String?, title: String, time: String, room: String, description: String, eventLat: String, eventLng: String, perks: [String]) {
        self._showEvent = showEvent
        self.imagePath = imagePath
        self.title = title
        self.time = time
        self.room = room
        self.description = description
        self.eventLat = eventLat
        self.eventLng = eventLng
        self.perks = perks

        // Retrieve the favorited state from UserDefaults or set to false if not saved
        self._favorited = State(initialValue: UserDefaults.standard.bool(forKey: "favorited_\(title)"))
    }

    var body: some View {
        ZStack {
            // Scrollable content
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Header with title and close button
                    HStack {
                        Text(title)
                            .font(.system(size: 28, weight: .bold))
                            .lineLimit(2)
                            .padding(.leading)

                        Spacer()

                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.red)
                            .onTapGesture {
                                showEvent = false
                            }
                            .padding(.trailing)
                    }
                    .padding(.top, 10)

                    // Event image
                    if let imagePath = imagePath, let url = URL(string: imagePath) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 200)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                        } placeholder: {
                            ProgressView()
                                .frame(maxHeight: 200)
                        }
                    }

                    // Event details
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Time: \(time)")
                            .font(.title3)
                            .fontWeight(.semibold)

                        Text("Location: \(room)")
                            .font(.title3)
                            .fontWeight(.semibold)

                        Text(description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding(.top)
                    }

                    // Perks section
                    if !perks.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Perks")
                                .font(.headline)

                            ForEach(perks, id: \.self) { perk in
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text(perk)
                                        .font(.body)
                                }
                            }
                        }
                        .padding(.top)
                    }

                    Spacer() // Allows scrolling content to push up
                }
                .padding()
            }

            // Fixed bottom action buttons
            VStack {
                Spacer()
                HStack(spacing: 16) {
                    Spacer()

                    // Get Directions Button
                    Button(action: {
                        openMapApp(latitude: eventLat, longitude: eventLng)
                        showEvent = false
                    }) {
                        HStack {
                            Image(systemName: "map.fill")
                            Text("Get Directions")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 275) // Adjusted width
                        .frame(height: 65)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    .padding(.bottom, 10)

                    // Favorite Button
                    Button(action: {
                        favorited.toggle() // This toggles the favorited state
                        // Save the favorited state to UserDefaults
                        UserDefaults.standard.set(favorited, forKey: "favorited_\(title)")
                    }) {
                        Image(systemName: favorited ? "heart.fill" : "heart")
                            .font(.system(size: 36))
                            .foregroundColor(favorited ? .red : .gray)
                    }
                    .padding(.bottom, 10)

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 20) // Safe area spacing for devices with no home button
                .background(Color(UIColor.systemBackground).opacity(0.95)) // Background to distinguish buttons
            }
        }
        .background(Color(UIColor.systemBackground))
        .edgesIgnoringSafeArea(.bottom)
    }

    // Open Map App Helper
    private func openMapApp(latitude: String, longitude: String) {
        if let lat = Double(latitude), let lng = Double(longitude) {
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            let placemark = MKPlacemark(coordinate: coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = title
            mapItem.openInMaps()
        }
    }
}
