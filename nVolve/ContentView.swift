//
//  ContentView.swift
//  mapkit
//
//  Created by Rasheed Nolley on 10/28/24.
//

import SwiftUI
import MapKit
struct ContentView: View {
    @State private var position : MapCameraPosition = .automatic
    
    var body: some View {
        VStack {
            HStack{
                Text("Filters")
                Spacer()
                Image(systemName: "slider.horizontal.3")
            }.padding().overlay(
              Rectangle()
                .stroke(Color.black, lineWidth: 1)
            )
            Map(position: $position) {
                Marker("Towson University", coordinate: CLLocationCoordinate2D(latitude: 39.3937,longitude: -76.6082))
            }.mapStyle(.standard).frame(height: 400)
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
