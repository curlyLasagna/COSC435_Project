//
//  CardView.swift
//  nVolve
//
//  Created by Abdalla Abdelmagid on 11/11/24.
//

import SwiftUI

struct CardView: View {
    var imagePath: String?
    var title: String
    var time: String
    var room: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let imagePath = imagePath {
                AsyncImage(url: URL(string: imagePath)) {
                    image in image.resizable()
                        .scaledToFit()
                        .frame(height: 120)
//                        .clipped()
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView("Boof")
                }
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                Text("\(time) / \(room)")
                    .font(.caption)
                    .bold()

                Text("Description")
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
    }
}
