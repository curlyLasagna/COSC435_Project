//
//  FilterOverlay.swift
//  nVolve
//
//  Created by Romerico David on 11/25/24.
//

import SwiftUI

struct FilterOverlay: View {
    let filterViewModel: FilterViewModel
    @Binding var showingFilters: Bool

    var body: some View {
        ZStack {
            Color.black
                .opacity(
                    0.3
                )
                .ignoresSafeArea()
                .onTapGesture {
                    showingFilters = false
                }

            FilterBody(
                viewModel: filterViewModel,
                dismiss: {
                    showingFilters = false
                }
            )
            .transition(
                .move(
                    edge: .trailing
                )
            )
        }
    }
}
