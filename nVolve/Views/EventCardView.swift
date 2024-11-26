//
//  EventCard.swift
//  nVolve
//
//  Created by Abdalla Abdelmagid on 11/11/24.
//

import SwiftUI

struct EventCard: View {
    let event: InvolvedEvent?
    let date: String
    let imagePath: String?
    @Binding var showEvent: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let imagePath = imagePath {
                AsyncImage(url: URL(string: imagePath)) { image in
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
                Text(event?.eventName ?? "Event")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                Text("\(date) / \(event?.eventLocation ?? "Room")")
                    .font(.caption)
                    .bold()

                Text(event?.eventDescription ?? "Description")
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
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.yellow, lineWidth: 1)
        )
        .shadow(color: Color.gray.opacity(0.2), radius: 2, x: 0, y: 1)
        .onTapGesture {
            showEvent = true
        }
        .fullScreenCover(isPresented: $showEvent) {
            EventInfoView(
                showEvent: $showEvent,
                title: event?.eventName ?? "Event Title",
                time: date,
                room: event?.eventLocation ?? "Room 204",
                description: event?.eventDescription ?? "Description",
                eventLat: String(format: "%.6f", event?.latitude ?? 0.0),
                eventLng: String(format: "%.6f", event?.longitude ?? 0.0),
                perks: event?.perks ?? ["Free Food", "Networking"]
            )
        }
    }
}

struct EventCard_Previews: PreviewProvider {
    static var previews: some View {
        EventCard(
            event: nil,
            date: "10:00 AM",
            imagePath: "https://via.placeholder.com/300",
            showEvent: .constant(false)
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
