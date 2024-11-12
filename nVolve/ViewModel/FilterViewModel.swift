//
//  FilterViewModel.swift
//  Demo
//
//  Created by Abdalla Abdelmagid on 11/11/24.
//

import SwiftUI

class FilterViewModel: ObservableObject {
    @Published var selectedFilters: Set<String> = []
    @Published var isShowing: Bool = false
    
    let themeFilters = ["Theme 1", "Theme 2", "Theme 3"]
    let categoryFilters = ["Category 1", "Category 2", "Category 3", "Category 4", "Category 5", "Category 6"]
    let perkFilters = ["Perk 1", "Perk 2", "Perk 3"]
    let locationFilters = ["Nearby", "Union", "Burdick field"]
    
    func clearFilters() {
        selectedFilters.removeAll()
    }
    
    func applyFilters() {
        isShowing = false
        // Add any additional filter application logic here
    }
}
