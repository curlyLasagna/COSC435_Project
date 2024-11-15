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
    
    let themeFilters = ["Arts & Music", "Athletics", "Cultural", "Community Service", "Open House", "Spiritual", "Meeting/Special Gathering", "Social/Entertainment", "Fundraising", "Learning", "Training"]
    let perkFilters = ["Free Food", "Free Stuff"]
    let locationFilters = ["Nearby", "Union", "Psychology Building", "Liberal Arts", "Arts", "Newman Center", "TU Arena", "Tiger Plaza", "Library", "West Village Dining", "Lecture Hall", "United Stadium", "Burdick Field"]
    
    func clearFilters() {
        selectedFilters.removeAll()
    }
    
    func applyFilters() {
        // Add any filter application logic here
    }
}
