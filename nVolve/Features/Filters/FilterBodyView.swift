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
            // TU grey background
            Color(red: 0.235, green: 0.235, blue: 0.235)
                .ignoresSafeArea()

            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Header with Filters text and logo
                    HStack {
                        Text("FILTERS")
                            .font(.system(size: 28))
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Spacer()

                        Image("tu-logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75, height: 75)
                    }

                    VStack(alignment: .leading, spacing: 18) {
                        FilterSection(
                            title: "Themes",
                            filters: viewModel.themeFilters,
                            selectedFilters: $viewModel.selectedFilters
                        )
                        FilterSection(
                            title: "Perks",
                            filters: viewModel.perkFilters,
                            selectedFilters: $viewModel.selectedFilters
                        )
                        FilterSection(
                            title: "Location",
                            filters: viewModel.locationFilters,
                            selectedFilters: $viewModel.selectedFilters
                        )
                    }

                    Spacer()

                    HStack(spacing: 10) {
                        Button(action: viewModel.clearFilters) {
                            Text("Clear filters")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.yellow)
                                .cornerRadius(8)
                        }

                        Button(action: {
                            viewModel.applyFilters()
                            dismiss()
                        }) {
                            Text("Apply")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(8)
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
