//
//  MapSection.swift
//  nVolve
//
//  Created by Romerico David on 11/25/24.
//
import SwiftUI
import MapKit

struct MapSection: View {
    var viewModel: ContentViewModel
    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        VStack(
            spacing: 0
        ) {
            Map(
                position: $position
            ) {
                ForEach(
                    viewModel.events
                ) {
                    event in
                    Marker(
                        event.eventName ?? "boof",
                        coordinate: viewModel.getCoordinates(
                            latitude: event.latitude,
                            longitude: event.longitude
                        )
                    )
                }
            }
            .mapStyle(
                .standard
            )
            .frame(
                height: 400
            )
            .colorScheme(
                .dark
            )

            EventsHeader()
        }
    }
}
