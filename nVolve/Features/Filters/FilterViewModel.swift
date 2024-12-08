//
//  FilterViewModel.swift
//  nVolve
//
//  Created by Abdalla Abdelmagid on 11/11/24.
//

import SwiftUI

class FilterViewModel: ObservableObject {
    @Published var selectedFilters: Set<String> = []
    @Published var showingFilters: Bool = false
    var contentViewModel: ContentViewModel

    init(contentViewModel: ContentViewModel) {
        self.contentViewModel = contentViewModel
    }

    let themeFilters = [
        "Arts & Music", "Athletics", "Cultural", "Community Service",
        "Open House", "Spiritual", "Meeting/Special Gathering",
        "Social/Entertainment", "Fundraising", "Learning", "Training",
    ]

    let perkFilters = ["Free Food", "Free Stuff"]

    let locationFilters = [
        "Nearby", "Union", "Psychology Building", "Liberal Arts", "Arts",
        "Newman Center", "TU Arena", "Tiger Plaza", "Library",
        "West Village Dining", "Lecture Hall", "United Stadium",
        "Burdick Field",
    ]

    func clearFilters() {
        selectedFilters.removeAll()
        contentViewModel.filteredEvents = contentViewModel.events // Reset filteredEvents
    }

    func applyFilters() {
        let originalEvents = contentViewModel.events
        
        // If no filters are selected, show all events
        guard !selectedFilters.isEmpty else {
            contentViewModel.filteredEvents = originalEvents
            return
        }
        
        contentViewModel.filteredEvents = originalEvents.filter { event in
            // Apply the selected filters
            var matches = false

            // Match themes
            if !selectedFilters.isDisjoint(with: event.theme) {
                matches = true
            }

            // Match perks
            if !selectedFilters.isDisjoint(with: event.perks) {
                matches = true
            }

            // Match locations
            if selectedFilters.contains(event.eventLocation) {
                matches = true
            }

            return matches
        }
    }
}
