//
//  FilterView.swift
//  nVolve
//
//  Created by Abdalla Abdelmagid on 11/11/24.
//

import SwiftUI

struct FilterBody: View {
    @ObservedObject var viewModel: FilterViewModel
    var dismiss: () -> Void

    var body: some View {
        ZStack {
            // Background color
            Color(.systemGray6)
                .ignoresSafeArea()

            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) { // Reduced spacing here
                    // Header with Filters text and logo
                    HStack {
                        Text("Filters")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)

                        Spacer()

                        Image("tu-background")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75, height: 75)
                    }

                    // Filter Sections
                    VStack(alignment: .leading, spacing: 16) { // Consistent spacing
                        FilterSelection(
                            title: "Themes",
                            filters: viewModel.themeFilters,
                            selectedFilters: $viewModel.selectedFilters
                        )
                        FilterSelection(
                            title: "Perks",
                            filters: viewModel.perkFilters,
                            selectedFilters: $viewModel.selectedFilters
                        )
                        FilterSelection(
                            title: "Location",
                            filters: viewModel.locationFilters,
                            selectedFilters: $viewModel.selectedFilters
                        )
                    }

                    Spacer()

                    // Action Buttons
                    HStack(spacing: 12) {
                        Button(action: viewModel.clearFilters) {
                            Text("Clear Filters")
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                        }

                        Button(action: {
                            viewModel.applyFilters()
                            dismiss()
                        }) {
                            Text("Apply")
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.yellow)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                        }
                    }
                    .padding(.bottom)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
