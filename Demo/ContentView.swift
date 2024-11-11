//
//  ContentView.swift
//  Demo
//
//  Created by Abdalla Abdelmagid on 11/10/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Filters")
                    Spacer()
                    Button(action: {
                        viewModel.showingFilters.toggle()
                    }) {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
                .padding()
                .overlay(
                    Rectangle()
                        .stroke(Color.black, lineWidth: 1)
                )
                
                Map(position: $viewModel.position) {
                    Marker("Towson University", coordinate: viewModel.towsonCoordinate)
                }
                .mapStyle(.standard)
                .frame(height: 400)
                
                Spacer()
            }
            
            if viewModel.showingFilters {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        viewModel.showingFilters = false
                    }
                
                FilterView(viewModel: viewModel.filterViewModel)
                    .transition(.move(edge: .trailing))
            }
        }
    }
}

#Preview {
    ContentView()
}
