//
//  DirectionsViewModel.swift
//  nVolve
//
//  Created by Rasheed Nolley on 11/18/24.
//
import SwiftUI
import CoreLocation
import CoreLocationUI
import MapKit


func openMapApp(latitude: Double, longitude: Double) {
    let urlString = "http://maps.apple.com/?q=\(latitude),\(longitude)"
    if let url = URL(string: urlString) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
func openMapAppWithDirections(latitude: Double, longitude: Double) {
    let urlString = "http://maps.apple.com/?daddr=\(latitude),\(longitude)"
    if let url = URL(string: urlString) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

