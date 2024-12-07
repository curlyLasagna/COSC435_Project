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
            Spacer()
            Button(
                action: {
                    showingFilters.toggle()
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 24)) // Increase icon size
                }
        }
        .padding()
    }
}
