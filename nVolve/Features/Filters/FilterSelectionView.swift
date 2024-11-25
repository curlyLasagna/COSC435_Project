//
//  FilterSelection.swift
//  nVolve
//
//  Created by Abdalla Abdelmagid on 11/11/24.
//

import SwiftUI

struct FilterSectionView: View {
    let title: String
    let filters: [String]
    @Binding var selectedFilters: Set<String>

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 20))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom, 6)

            FilterLayoutView(spacing: 8) {
                ForEach(filters, id: \.self) { filter in
                    FilterChipView(
                        text: filter,
                        isSelected: selectedFilters.contains(filter)
                    ) {
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
