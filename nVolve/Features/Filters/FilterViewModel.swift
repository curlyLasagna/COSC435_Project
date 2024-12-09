//
//  FilterViewModel.swift
//  nVolve
//
//  Created by Abdalla Abdelmagid on 11/11/24.
//

import Foundation
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
        "Open House", "Spiritual", "Meeting / Special Gathering",
        "Social / Entertainment", "Fundraising", "Learning", "Training",
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
        
        guard !selectedFilters.isEmpty else {
            contentViewModel.filteredEvents = originalEvents
            return
        }
        
        contentViewModel.filteredEvents = originalEvents.filter { event in
            // Apply the selected filters
            var matches = false
            
            // Split the filter words into a set of words for comparison
            let filterWords = selectedFilters.flatMap { $0.lowercased().split(separator: " ") }
            
            // Check if any word from filterWords exists in event's theme
            for theme in event.theme {
                let themeWords = theme.lowercased().split(separator: " ")
                
                // Check for any common word between filter and theme
                if themeWords.contains(where: { filterWords.contains($0) }) {
                    matches = true
                    break // If one match is found, we can stop further checking
                }
                
                // Check if the filter and theme are similar enough using Levenshtein distance
                for filter in selectedFilters {
                    if areStringsSimilar(filter.lowercased(), theme.lowercased()) {
                        matches = true
                        break
                    }
                }
            }
            
            // Check if location matches (similar to how themes are checked)
            for location in selectedFilters {
                let eventLocationWords = event.eventLocation.lowercased().split(separator: " ")
                let filterLocationWords = location.lowercased().split(separator: " ")
                
                // Check if any word from filterLocationWords exists in event's location
                if eventLocationWords.contains(where: { filterLocationWords.contains($0) }) {
                    matches = true
                    break // If one match is found, we can stop further checking
                }
                
                // Check if the filter and location are similar enough using Levenshtein distance
                if areStringsSimilar(location.lowercased(), event.eventLocation.lowercased()) {
                    matches = true
                    break
                }
            }

            // Match perks
            if !selectedFilters.isDisjoint(with: event.perks) {
                matches = true
            }

            return matches
        }
    }

    
    func areStringsSimilar(_ string1: String, _ string2: String, threshold: Int = 3) -> Bool {
        let distance = levenshteinDistance(string1.lowercased(), string2.lowercased())
        return distance <= threshold
    }

    func levenshteinDistance(_ lhs: String, _ rhs: String) -> Int {
        let lhsCount = lhs.count
        let rhsCount = rhs.count

        // Handle the case where either string is empty
        if lhsCount == 0 { return rhsCount }
        if rhsCount == 0 { return lhsCount }

        var dp = [[Int]](repeating: [Int](repeating: 0, count: rhsCount + 1), count: lhsCount + 1)

        for i in 0...lhsCount {
            dp[i][0] = i
        }

        for j in 0...rhsCount {
            dp[0][j] = j
        }

        // Now it's safe to iterate over the strings
        for i in 1...lhsCount {
            for j in 1...rhsCount {
                let lhsChar = lhs.index(lhs.startIndex, offsetBy: i - 1)
                let rhsChar = rhs.index(rhs.startIndex, offsetBy: j - 1)

                if lhs[lhsChar] == rhs[rhsChar] {
                    dp[i][j] = dp[i - 1][j - 1]
                } else {
                    dp[i][j] = min(dp[i - 1][j - 1], min(dp[i][j - 1], dp[i - 1][j])) + 1
                }
            }
        }

        return dp[lhsCount][rhsCount]
    }
}
