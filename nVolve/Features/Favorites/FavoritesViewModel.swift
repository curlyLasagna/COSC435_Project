//
//  FavoritesViewModel.swift
//  nVolve
//
//  Created by Romerico David on 12/2/24.
//

import SwiftUI

class FavoritesViewModel: ObservableObject {
    @Published var favoriteEvents: [InvolvedEvent] = [] {
        didSet {
            saveFavorites()
        }
    }

    // Reference to all events
    var allEvents: [InvolvedEvent] = []

    init() {
        loadFavorites()
        checkForReset()
    }

    func addFavorite(event: InvolvedEvent) {
        guard !isFavorited(event: event) else {
            print("FavoritesViewModel: Event \(event.id) is already favorited.")
            return
        }
        favoriteEvents.append(event)
        sortFavoritesByTime()
    }

    func removeFavorite(event: InvolvedEvent) {
        favoriteEvents.removeAll { $0.id == event.id }
    }

    func isFavorited(event: InvolvedEvent) -> Bool {
        let isFav = favoriteEvents.contains { $0.id == event.id }
        return isFav
    }

    func findEventByID(id: String?) -> InvolvedEvent? {
        guard let id = id else {
            print("FavoritesViewModel: findEventByID called with nil id.")
            return nil
        }
        let event = allEvents.first { $0.id == id }
        return event
    }

    private func sortFavoritesByTime() {
        favoriteEvents.sort { ($0.startDateParsed ?? Date()) < ($1.startDateParsed ?? Date()) }
    }

    // MARK: - Persistence Methods

    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(favoriteEvents) {
            UserDefaults.standard.set(data, forKey: "favoriteEvents")
        }
    }

    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favoriteEvents"),
           let events = try? JSONDecoder().decode([InvolvedEvent].self, from: data) {
            favoriteEvents = events
        }
    }

    // MARK: - Reset at Midnight

    private func checkForReset() {
        let lastResetDate = UserDefaults.standard.object(forKey: "lastResetDate") as? Date ?? Date()
        if !Calendar.current.isDateInToday(lastResetDate) {
            favoriteEvents = []
            UserDefaults.standard.set(Date(), forKey: "lastResetDate")
        }
    }
}
