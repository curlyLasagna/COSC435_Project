//
//  EventInfo.swift
//  nVolve
//
//  Created by Rasheed Nolley on 11/11/24.
//

import SwiftUI
import MapKit

struct EventInfo: View {
    @Binding var showEvent: Bool
    var imagePath: String?
    var title: String
    var time: String
    var room: String
    var description: String
    @State private var favorited = false

    var eventLat: String
    var eventLng: String

    var perks: [String]
    var eventID: String?
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel

    var body: some View {
        VStack(alignment: .leading) {
            // Header with Close Button
            HStack {
                Text(title)
                    .font(.system(size: 30))
                    .padding(.leading)
                Spacer()
                Image(systemName: "x.circle")
                    .font(.system(size: 30))
                    .foregroundColor(.red)
                    .padding(.trailing)
                    .onTapGesture {
                        showEvent = false
                    }
            }
            .padding(.top)

            // Event Image
            if let imagePath = imagePath, let url = URL(string: imagePath) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
            }

            // Event Details
            Text("Time: \(time)")
                .font(.title2)
            Text(room)
                .font(.title2)
            Text(description)
                .padding(.top)

            Spacer()

            // Perks
            if !perks.isEmpty {
                Text("Perks:")
                    .font(.headline)
                    .padding(.top)
                ForEach(perks, id: \.self) { perk in
                    Text("- \(perk)")
                        .padding(.leading)
                }
            }

            // Action Buttons
            HStack {
                Spacer()
                // Get Directions Button
                Button(action: {
                    openMapApp(latitude: eventLat, longitude: eventLng)
                    showEvent = false
                }) {
                    Text("Get Directions")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                // Favorite Button
                Image(systemName: favorited ? "heart.fill" : "heart")
                    .font(.system(size: 30))
                    .foregroundColor(.red)
                    .padding()
                    .onTapGesture {
                        favorited.toggle()
                        if let id = eventID, let event = favoritesViewModel.findEventByID(id: id) {
                            if favorited {
                                favoritesViewModel.addFavorite(event: event)
                            } else {
                                favoritesViewModel.removeFavorite(event: event)
                            }
                            showEvent = false
                        }
                    }
                Spacer()
            }
        }
        .padding()
        .onAppear {
            if let id = eventID, let event = favoritesViewModel.findEventByID(id: id) {
                favorited = favoritesViewModel.isFavorited(event: event)
            }
        }
    }
}
