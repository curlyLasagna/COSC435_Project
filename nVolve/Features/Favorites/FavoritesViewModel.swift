//
//  FavoritesViewModel.swift
//  nVolve
//
//  Created by Romerico David on 12/2/24.
//

import SwiftUI

class FavoritesViewModel: ObservableObject {
    @Published var favoriteEvents: [InvolvedEvent] = []
    var allEvents: [InvolvedEvent] = [] {
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

    func addFavorite(event: InvolvedEvent) {
        guard let eid = event.id else {
            return
        }
        guard !isFavorited(event: event) else {
            return
        }

        favoriteEventIDs.append(eid)
        rebuildFavorites()
        saveFavoriteEventIDs()
    }

    func removeFavorite(event: InvolvedEvent) {
        guard let eid = event.id else {
            return
        }

        favoriteEventIDs.removeAll { $0 == eid }
        rebuildFavorites()
        saveFavoriteEventIDs()
    }

    func isFavorited(event: InvolvedEvent) -> Bool {
        guard let eid = event.id else { return false }
        return favoriteEventIDs.contains(eid)
    }

    func findEventByID(id: String?) -> InvolvedEvent? {
        guard let id = id else {
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
        favoriteEvents.sort { (a: InvolvedEvent, b: InvolvedEvent) -> Bool in
            (a.startDate ?? "") < (b.startDate ?? "")
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
            let ids = try? JSONDecoder().decode([String].self, from: data)
        {
            favoriteEventIDs = ids
        } else {
            favoriteEventIDs = []
        }
    }

    // MARK: - Reset at Midnight
    private func checkForReset() {
        let lastResetDate =
            UserDefaults.standard.object(forKey: "lastResetDate") as? Date
            ?? Date()
        if !Calendar.current.isDateInToday(lastResetDate) {
            favoriteEventIDs = []
            favoriteEvents = []
            UserDefaults.standard.set(Date(), forKey: "lastResetDate")
            saveFavoriteEventIDs()
        }
    }
}
