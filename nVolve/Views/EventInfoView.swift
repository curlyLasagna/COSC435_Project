//
//  EventInfoView.swift
//  nVolve
//
//  Created by Rasheed Nolley on 11/11/24.
//

import SwiftUI

struct EventInfoView: View {
    @Binding var showEvent: Bool
    var event: InvolvedEvent
    @State private var favorited = false

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(event.eventName ?? "No Title")
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

                if let imagePath = event.imagePath {
                    AsyncImage(url: URL(string: "https://se-images.campuslabs.com/clink/images/\(imagePath)")) { image in
                        image.resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                }

                Text("Time: \(event.startDate ?? "No Time")")
                    .font(.title2)
                Text(event.eventLocation ?? "No Location")
                    .font(.title2)
                Text(event.eventDescription ?? "No Description")
                    .padding(.top)

                Spacer()

                if let perks = event.perks {
                    ForEach(perks, id: \.self) { perk in
                        Text(perk)
                            .padding()
                            .background(Color.yellow)
                            .cornerRadius(8)
                            .foregroundColor(.black)
                    }
                }

                HStack {
                    Spacer()
                    Button(action: {
                        // Handle Get Directions
                    }) {
                        Text("Get Directions")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 200)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        favorited.toggle()
                    }) {
                        Image(systemName: favorited ? "heart.fill" : "heart")
                            .font(.system(size: 30))
                            .foregroundColor(.red)
                            .padding()
                    }
                    Spacer()
                }
                .onChange(of: favorited) { newValue in
                    if newValue {
                        NotificationsManager.shared.scheduleNotification(for: event)
                    } else {
                        NotificationsManager.shared.cancelNotification(for: event)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            favorited = false // Set initial state based on user's subscription status if available
        }
    }
}

#Preview {
    EventInfoView(
        showEvent: .constant(true),
        event: InvolvedEvent(
            id: "1",
            orgName: "Org",
            orgPhoto: nil,
            eventName: "Sample Event",
            eventDescription: "This is a sample event description.",
            eventLocation: "Room 204",
            startDate: "2024-11-21T10:00:00Z",
            endDate: nil,
            imagePath: nil,
            eventTheme: nil,
            latitude: "39.394839",
            longitude: "-76.610880",
            perks: ["Free Food", "Networking"]
        )
    )
}
