//
//  EventsHeader.swift
//  nVolve
//
//  Created by Romerico David on 11/25/24.
//
import SwiftUI

struct EventsHeader: View {
    var body: some View {
        HStack {
            Text(
                "Events"
            )
            .font(
                .title2
            )
            .fontWeight(
                .bold
            )
            .padding(
                .leading,
                16
            )
            Spacer()
        }
        .padding(
            7
        )
        .overlay(
            Rectangle()
                .stroke(
                    Color.black,
                    lineWidth: 1
                )
        )
    }
}
