//
//  EventListSectionView.swift
//  nVolve
//
//  Created by Romerico David on 11/25/24.
//

import SwiftUI

struct EventListSection: View {
    @ObservedObject var viewModel: ContentViewModel
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel

    var sortedEvents: [InvolvedEvent] {
        var events = viewModel.events
        events.sort { (event1, event2) -> Bool in
            let isFav1 = favoritesViewModel.isFavorited(event: event1)
            let isFav2 = favoritesViewModel.isFavorited(event: event2)
            if isFav1 != isFav2 {
                return isFav1 && !isFav2
            } else {
                let date1 = event1.startDateParsed ?? Date()
                let date2 = event2.startDateParsed ?? Date()
                return date1 < date2
            }
        }
        return events
    }

    var body: some View {
        ScrollView(
            .horizontal,
            showsIndicators: true
        ) {
            HStack(
                spacing: 10
            ) {
                ForEach(
                    sortedEvents.indices,
                    id: \.self
                ) { index in
                    EventCard(
                        event: sortedEvents[index],
                        date: viewModel.getStartTime(dateAsString: sortedEvents[index].startDate),
                        imagePath: viewModel.getImages(imgPath: sortedEvents[index].imagePath)
                    )
                }
            }
            .padding(
                .horizontal
            )
        }
        .background(
            Color.white
        )
    }
}
