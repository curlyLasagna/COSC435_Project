//
//  FilterChip.swift
//  nVolve
//
//  Created by Abdalla Abdelmagid on 11/11/24.
//

import SwiftUI

struct FilterChipView: View {
    let text: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Text(text)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.yellow : Color.black.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.black.opacity(0.5), lineWidth: 1)
            )
            .onTapGesture(perform: onTap)
    }
}
