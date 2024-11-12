//
//  FilterView.swift
//  Demo
//
//  Created by Abdalla Abdelmagid on 11/11/24.
//

import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: FilterViewModel
    
    var body: some View {
        ZStack {
            // Plain white background
            Color(red: 0.235, green: 0.235, blue: 0.235)
                .ignoresSafeArea()
            
            Image("tu-logo")
                .resizable()
                .scaledToFit()
            
            // Content
            VStack(alignment: .leading, spacing: 20) {
                Text("FILTERS")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 18) {
                    FilterSection(title: "Themes",
                                  filters: viewModel.themeFilters,
                                  selectedFilters: $viewModel.selectedFilters)
                    FilterSection(title: "Categories",
                                  filters: viewModel.categoryFilters,
                                  selectedFilters: $viewModel.selectedFilters)
                    FilterSection(title: "Perks",
                                  filters: viewModel.perkFilters,
                                  selectedFilters: $viewModel.selectedFilters)
                    FilterSection(title: "Location",
                                  filters: viewModel.locationFilters,
                                  selectedFilters: $viewModel.selectedFilters)
                }
                
                Spacer()
                
                HStack(spacing: 10) {
                    Button(action: viewModel.clearFilters) {
                        Text("Clear filters")
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.yellow)
                            .cornerRadius(8)
                    }
                    
                    Button(action: viewModel.applyFilters) {
                        Text("Apply")
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

