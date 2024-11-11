//
//  FilterSelection.swift
//  Demo
//
//  Created by Abdalla Abdelmagid on 11/11/24.
//

import SwiftUI

struct FilterSection: View {
    let title: String
    let filters: [String]
    @Binding var selectedFilters: Set<String>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)  // Make section titles white
            
            FlowLayout(spacing: 8) {
                ForEach(filters, id: \.self) { filter in
                    FilterChip(text: filter,
                             isSelected: selectedFilters.contains(filter)) {
                        if selectedFilters.contains(filter) {
                            selectedFilters.remove(filter)
                        } else {
                            selectedFilters.insert(filter)
                        }
                    }
                }
            }
        }
    }
}
