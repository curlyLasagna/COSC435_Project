//
//  MapSelectionView.swift
//  nVolve
//
//  Created by Romerico David on 12/7/24.
//

import SwiftUI
import MapKit

struct MapSelectionSheet: View {
    @Binding var showBottomSheet: Bool
    var eventLat: String
    var eventLng: String
    var title: String

    var body: some View {
        VStack(spacing: 20) {
            Text("Get Directions")
                .font(.system(size: 24, weight: .bold))
                .padding(.top)
            Divider()
            VStack(alignment: .leading, spacing: 20) {
                Button(action: {
                    openAppleMaps(latitude: eventLat, longitude: eventLng)
                    showBottomSheet = false
                }) {
                    HStack {
                        Image(systemName: "map")
                            .foregroundColor(.black)
                            .frame(width: 24, height: 24)
                        Text("Open in Apple Maps")
                            .foregroundColor(.black)
                            .font(.system(size: 20, weight: .medium))
                            .font(.body)
                    }
                }
                Divider()
                Button(action: {
                    openGoogleMaps(latitude: eventLat, longitude: eventLng)
                    showBottomSheet = false
                }) {
                    HStack {
                        Image(systemName: "map")
                            .foregroundColor(.black)
                            .frame(width: 24, height: 24)
                        Text("Open in Google Maps")
                            .foregroundColor(.black)
                            .font(.system(size: 20, weight: .medium))
                            .font(.body)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 20)
        .frame(height: 100)
    }

    private func openAppleMaps(latitude: String, longitude: String) {
        if let lat = Double(latitude), let lng = Double(longitude) {
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            let placemark = MKPlacemark(coordinate: coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = title
            mapItem.openInMaps()
        }
    }

    private func openGoogleMaps(latitude: String, longitude: String) {
        let urlString = "comgooglemaps://?q=\(latitude),\(longitude)&zoom=14"
        if let googleMapsURL = URL(string: urlString),
           UIApplication.shared.canOpenURL(googleMapsURL) {
            UIApplication.shared.open(googleMapsURL, options: [:], completionHandler: nil)
        } else {
            // If they don't have Google Maps, it reverts back to Apple Maps
            openAppleMaps(latitude: latitude, longitude: longitude)
        }
    }
}
