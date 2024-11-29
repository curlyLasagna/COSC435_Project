//
//  EventListSectionView.swift
//  nVolve
//
//  Created by Romerico David on 11/25/24.
//

import SwiftUI

struct EventListSection: View {
    var viewModel: ContentViewModel
    @State private var showEvent = false

    var body: some View {
        ScrollView(
            .horizontal,
            showsIndicators: true
        ) {
            HStack(
                spacing: 10
            ) {
                ForEach(
                    viewModel.events.indices,
                    id: \.self
                ) { index in
                    EventCard(
                        event:
                            viewModel
                            .events[index],
                        date:
                            viewModel
                            .getStartTime(
                                dateAsString: viewModel.events[index].startDate
                            ),
                        imagePath:
                            viewModel
                            .getImages(
                                imgPath: viewModel.events[index].imagePath
                            )
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
