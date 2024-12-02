//
//  FavoriteViewModel.swift
//  nVolve
//
//  Created by Romerico David on 12/2/24.
//

import SwiftUI

class FavoritesViewModel: ObservableObject {
    // TODO: Clear favoriteEvents at 12:00 am
    @Published var favoriteEvents: [InvolvedEvent] = []
    
    func addFavorite(event: InvolvedEvent) {
        guard !isFavorited(event: event) else { return }
        favoriteEvents.append(event)
        sortFavoritesByTime()
    }

    func removeFavorite(event: InvolvedEvent) {
        favoriteEvents.removeAll { $0.id == event.id }
    }

    func isFavorited(event: InvolvedEvent) -> Bool {
        favoriteEvents.contains { $0.id == event.id }
    }

    private func sortFavoritesByTime() {
        favoriteEvents.sort { ($0.startDateParsed ?? Date()) < ($1.startDateParsed ?? Date()) }
    }
}
