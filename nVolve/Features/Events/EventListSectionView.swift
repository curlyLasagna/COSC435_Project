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
        let scrollContent = makeEventList()
        
        ScrollView(.horizontal, showsIndicators: true) {
            scrollContent
                .padding(.horizontal)
        }
        .background(Color.white)
    }
    
    private func makeEventList() -> some View {
        HStack(spacing: 10) {
            ForEach(viewModel.events) { event in
                let startTime = viewModel.getStartTime(dateAsString: event.time)
                let imagePath = viewModel.getImages(imgPath: event.eventImage)
                
                EventCard(
                    event: event,
                    date: startTime,
                    imagePath: imagePath
                )
            }
        }
    }
}
