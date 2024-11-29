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
    
    // Placeholder data
    var eventLat: String
    var eventLng: String
    
    var perks: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
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
            
            // AsyncImage to load image from URL
            if let imagePath = imagePath, let url = URL(string: imagePath) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
            }
            
            Text("Time: \(time)")
                .font(.title2)
            Text(room)
                .font(.title2)
            Text(description)
                .padding(.top)
            
            Spacer()
            
            if !perks.isEmpty {
                Text("Perks:")
                    .font(.headline)
                    .padding(.top)
                ForEach(perks, id: \.self) { perk in
                    Text("- \(perk)")
                        .padding(.leading)
                }
            }
            
            HStack {
                Spacer()
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
                Image(systemName: favorited ? "heart.fill" : "heart")
                    .font(.system(size: 30))
                    .foregroundColor(.red)
                    .padding()
                    .onTapGesture {
                        favorited.toggle()
                    }
                Spacer()
            }
        }
        .padding()
    }
}
