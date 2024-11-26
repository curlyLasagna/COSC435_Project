//
//  FilterHeader.swift
//  nVolve
//
//  Created by Romerico David on 11/25/24.
//
import SwiftUI

struct FilterHeader: View {
    @Binding var showingFilters: Bool

    var body: some View {
        HStack {
            Text(
                "Filters"
            )
            Spacer()
            Button(
                action: {
                    showingFilters.toggle()
                }) {
                    Image(
                        systemName: "slider.horizontal.3"
                    )
                }
        }
        .padding()
        .overlay(
            Rectangle()
                .stroke(
                    Color.black,
                    lineWidth: 1
                )
        )
    }
}
