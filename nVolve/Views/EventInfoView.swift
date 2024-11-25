//
//  Eventinfo.swift
//  nVolve
//
//  Created by Rasheed Nolley on 11/11/24.
//

import SwiftUI

struct EventInfoView: View {
    @Binding var showEvent: Bool
//    var image: Image
    var title: String
    var time: String
    var room: String
    var description: String
    @State private var favorited = false

    var perks: [String]

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .font(.system(size: 50))
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

//                image
//                    .resizable()
//                    .scaledToFit()

                Text("Time: \(time)")
                    .font(.largeTitle)
                Text("\(room)")
                    .font(.largeTitle)
                Text(description)

                Spacer()

                List(perks, id: \.self) { perk in
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundColor(Color(red: 1.0, green: 0.733, blue: 0.0))
                        Text(perk).foregroundColor(.white)
                    }
                }

                HStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.blue)
                            .frame(width: 300, height: 50)
                        Text("Get Directions")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                    }

                    Image(systemName: favorited ? "heart.fill" : "heart")
                        .font(.system(size: 30))
                        .foregroundColor(.red)
                        .frame(height: 70)
                        .onTapGesture {
                            favorited.toggle()
                        }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    EventInfoView(
        showEvent: .constant(true),
//        image: Image(systemName: "photo"),
        title: "Event Title",
        time: "10:00 AM",
        room: "Room 204",
        description: "hope this works",
        perks: ["free food", "arts"]
    )
}
