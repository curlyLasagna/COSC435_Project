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
        //.userLocation(
//        fallback: .camera(
//            MapCamera(centerCoordinate: .Start, distance: 200
//                     )
//        )
//    )
    @StateObject private var viewModel = MarkerModel()
    @State private var showevent = false
    
    var body: some View {
        
        VStack (spacing:0){
            HStack{
                Text("Filters")
                Spacer()
                Image(systemName: "slider.horizontal.3")
            }.padding().overlay(
                Rectangle()
                    .stroke(Color.black, lineWidth: 1)
                    .onTapGesture {
                        //shoud display card data 
                    }
            )
          
            Map(position: $position) {
                ForEach(viewModel.markers, id: \.name) { marker in
                    Marker(marker.name, systemImage: marker.image, coordinate: marker.coordinate)
                        .tint(marker.color)
                        
                    
                }
            }.mapStyle(.standard).frame(height: 400)
                .colorScheme(.dark)
                .onTapGesture{
                  
                }
            
        
            HStack {
                Text("Events")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading, 16)
                Spacer()
            }
            .padding(.all,7).overlay(
                Rectangle()
                    .stroke(Color.black, lineWidth: 1)
            )
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: 10) {
                    ForEach(0..<15, id: \.self) { index in
                        Card(image: Image(systemName: "photo"),
                             title: "Event \(index + 1)",
                             time: "10:00 AM",
                             room: "Room 204")
                    }.onTapGesture {
                        //should have a link to the page of data
                        showevent=true
                    }.fullScreenCover(isPresented:$showevent){
                        EventInfo(
                            showEvent: $showevent,image: Image(systemName: "photo"),
                                  title: "Event Title",
                                  time: "10:00 AM",
                                  room: "Room 204",
                                  description: "hope this works",
                                  perks:["free food","arts"])
                    }
                }
                .background(Color.gray)
                .padding(.horizontal)
            }

        }
    }
}
#Preview {
    ContentView()
}
