//
//  FavoritesViewModel.swift
//  nVolve
//
//  Created by Romerico David on 12/2/24.
//

import SwiftUI

class FavoritesViewModel: ObservableObject {
    @Published var favoriteEvents: [EventModel] = [] {
        didSet {
            notificationsViewModel?.scheduleNotificationsForFavorites()
        }
    }
    var allEvents: [EventModel] = [] {
        didSet {
            rebuildFavorites()
        }
    }

    private var favoriteEventIDs: [String] = []
    var notificationsViewModel: NotificationsViewModel!

    init() {
        loadFavoriteEventIDs()
        checkForReset()
        self.notificationsViewModel = NotificationsViewModel(favoritesViewModel: self)

    }
    func addFavorite(event: EventModel) {
        guard !isFavorited(event: event) else {
            return
        }
        favoriteEventIDs.append(event.id)
        saveFavoriteEventIDs()
        rebuildFavorites()
    }

    func removeFavorite(event: EventModel) {
        favoriteEventIDs.removeAll { $0 == event.id }
        saveFavoriteEventIDs()
        rebuildFavorites()
    }

    func isFavorited(event: EventModel) -> Bool {
        let result = favoriteEventIDs.contains(event.id)
        return result
    }

    func findEventByID(id: String?) -> EventModel? {
        guard let id = id else {
            return nil
        }
        let event = allEvents.first { $0.id == id }
        return event
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
