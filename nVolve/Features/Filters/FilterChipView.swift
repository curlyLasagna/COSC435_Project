//
//  FilterChip.swift
//  nVolve
//
//  Created by Abdalla Abdelmagid on 11/11/24.
//

import SwiftUI

struct FilterChip: View {
    let text: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Text(text)
            .font(.system(size: 14))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.yellow.opacity(0.7) : Color.white)
            .foregroundColor(isSelected ? Color.black : Color.black)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.black : Color.gray.opacity(0.5), lineWidth: 1)
            )
            .onTapGesture(perform: onTap)
    }
}
