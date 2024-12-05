//
//  EventCard.swift
//  nVolve
//
//  Created by Abdalla Abdelmagid on 11/11/24.
//

import SwiftUI

struct EventCard: View {
    let event: InvolvedEvent
    let date: String
    let imagePath: String?
    var viewModel: ContentViewModel = ContentViewModel()
    var strippedEventDescription: String { return viewModel.stripHTML(text: event.eventDescription) }
    @State var showEvent: Bool = false
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let imagePath = imagePath, let url = URL(string: imagePath) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 120)
                        .clipped()
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.purple, lineWidth: 1)
                        )
                } placeholder: {
                    ProgressView("Loading...")
                }
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(event.eventName ?? "Event")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                Text("\(date) / \(event.eventLocation ?? "Room")")
                    .font(.caption)
                    .bold()

                Text(strippedEventDescription)
                    .font(.caption)
                    .lineLimit(2)
            }
            .padding(8)
            .background(Color.yellow.opacity(0.8))
            .cornerRadius(8)
            .foregroundColor(.black)
        }
        .foregroundColor(.black)
        .frame(width: 180, height: 240)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            // Display heart icon if favorited
            VStack {
                HStack {
                    Spacer()
                    if favoritesViewModel.isFavorited(event: event) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.red)
                            .padding(8)
                    }
                }
                Spacer()
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.yellow, lineWidth: 1)
        )
        .shadow(color: Color.gray.opacity(0.2), radius: 2, x: 0, y: 1)
        .onTapGesture {
            showEvent = true
        }
        .fullScreenCover(isPresented: $showEvent) {
            EventInfo(
                showEvent: $showEvent,
                imagePath: imagePath,
                title: event.eventName ?? "Event Title",
                time: date,
                room: event.eventLocation ?? "Room 204",
                description: strippedEventDescription,
                eventLat: event.latitude ?? "0.0",
                eventLng: event.longitude ?? "0.0",
                perks: event.perks ?? [],
                eventID: event.id
            )
        }
    }
}
