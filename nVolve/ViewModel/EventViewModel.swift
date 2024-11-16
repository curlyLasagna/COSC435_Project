//
//  EventViewModel.swift
//  nVolve
//
//  Created by Luis on 11/12/24.
//

import Alamofire
import UIKit

@Observable class EventViewModel {
    var events: [InvolvedEvents] = []
    // ':' is encoded as %3
    // 'T' is the separator between time and date
    func fetchTodayEvents() {
        let encodedToday = ISO8601DateFormatter().string(from: Date())
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let endpoint =
            "https://involved.towson.edu/api/discovery/event/search?startsAfter=\(encodedToday)"
        AF.request(endpoint).responseDecodable(of: [InvolvedEvents].self) {
            response in
            switch response.result {
            case .success(let data):
                print(data)
            case .failure(let err):
                print(err)

            }
        }
    }

    func fetchEventsByPerks() {

    }

    func fetchEventsByTheme() {

    }
}
