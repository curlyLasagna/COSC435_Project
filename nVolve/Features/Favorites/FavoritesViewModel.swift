//
//  FavoritesViewModel.swift
//  nVolve
//
//  Created by Romerico David on 12/2/24.
//

import SwiftUI

class FavoritesViewModel: ObservableObject {
    @Published var favoriteEvents: [EventModel] = []
    var allEvents: [EventModel] = [] {
        didSet {
            // Rebuild favoriteEvents whenever allEvents changes
            rebuildFavorites()
        }
    }

    private var favoriteEventIDs: [String] = []

    init() {
        loadFavoriteEventIDs()
        checkForReset()
    }

    func addFavorite(event: EventModel) {
        guard !isFavorited(event: event) else {
            print("FavoritesViewModel: Event \(event.id) is already favorited.")
            return
        }

        favoriteEventIDs.append(event.id)
        rebuildFavorites()
        saveFavoriteEventIDs()
    }

    func removeFavorite(event: EventModel) {
        favoriteEventIDs.removeAll { $0 == event.id }
        rebuildFavorites()
        saveFavoriteEventIDs()
    }

    func isFavorited(event: EventModel) -> Bool {
        return favoriteEventIDs.contains(event.id)
    }

    func findEventByID(id: String?) -> EventModel? {
        guard let id = id else {
            print("FavoritesViewModel: findEventByID called with nil id.")
            return nil
        }
        return allEvents.first { $0.id == id }
    }

    private func rebuildFavorites() {
        favoriteEvents = favoriteEventIDs.compactMap { eid in
            allEvents.first { $0.id == eid }
        }
        sortFavoritesByTime()
    }

    private func sortFavoritesByTime() {
        favoriteEvents.sort { (a: EventModel, b: EventModel) -> Bool in
            (a.time) < (b.time)
        }
    }

    // MARK: - Persistence Methods (storing only IDs)
    private func saveFavoriteEventIDs() {
        if let data = try? JSONEncoder().encode(favoriteEventIDs) {
            UserDefaults.standard.set(data, forKey: "favoriteEventIDs")
        }
    }

    private func loadFavoriteEventIDs() {
        if let data = UserDefaults.standard.data(forKey: "favoriteEventIDs"),
           let ids = try? JSONDecoder().decode([String].self, from: data) {
            favoriteEventIDs = ids
        } else {
            favoriteEventIDs = []
        }
    }

    // MARK: - Reset at Midnight
    private func checkForReset() {
        let lastResetDate = UserDefaults.standard.object(forKey: "lastResetDate") as? Date ?? Date()
        if !Calendar.current.isDateInToday(lastResetDate) {
            favoriteEventIDs = []
            favoriteEvents = []
            UserDefaults.standard.set(Date(), forKey: "lastResetDate")
            saveFavoriteEventIDs()
        }
    }
}
