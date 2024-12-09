//
//  EventCard.swift
//  nVolve
//
//  Created by Abdalla Abdelmagid on 11/11/24.
//

import SwiftUI

struct EventCard: View {
    let event: EventModel
    @State var showEvent: Bool = false
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Event Image or Placeholder
            if let url = URL(string: event.eventImage) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 132)
                        .frame(width: 200)
                        .clipped()
                        .cornerRadius(8)
                } placeholder: {
                    placeholderImage
                }
            } else {
                placeholderImage
            }

            // Event Details
            VStack(alignment: .leading, spacing: 4) {
                Text(event.eventName)
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(1)

                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(
                            Color(red: 1.0, green: 0.733, blue: 0.0))
                    Text(parseEventTime(event.time))
                        .font(.caption)
                        .foregroundColor(.black)
                        .lineLimit(1)
                }

                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(Color(red: 1.0, green: 0.733, blue: 0.0))
                    Text(event.eventLocation)
                        .font(.caption)
                        .foregroundColor(.black)
                        .lineLimit(1)
                }
            }
            .padding([.horizontal, .bottom], 8)
        }
        .frame(width: 200, height: 220)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 2)
        )
        .overlay(
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
                .stroke(Color.black, lineWidth: 2)
        )
        .onTapGesture {
            showEvent = true
        }
        .fullScreenCover(isPresented: $showEvent) {
            EventInfo(
                showEvent: $showEvent,
                event: event
            )
        }
        .padding(.trailing, 5)
        .padding(.vertical, 10)
    }
}

private var placeholderImage: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.3))
            .frame(height: 120)
            .overlay(
                VStack {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                    Text("No Image Available")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            )
    }

private func parseEventTime(_ timeString: String) -> String {
    let isoFormatter = ISO8601DateFormatter()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm a"
    dateFormatter.amSymbol = "am"
    dateFormatter.pmSymbol = "pm"

    if let date = isoFormatter.date(from: timeString) {
        return dateFormatter.string(from: date)
    }

    return "Invalid Time"
}
