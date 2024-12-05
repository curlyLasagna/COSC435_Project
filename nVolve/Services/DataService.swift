//
//  DataService.swift
//  nVolve
//
//  Created by Luis on 11/24/24.
//
import Alamofire
import SwiftUI

class DataService {

    var events: [EventModel] = []
    
    func transformToEvent () {
        
    }
    
    private func fetchInvolved() {
        // This function is only for involved @ TU. A refactor will be required to accodomate other data sources
        let encodedStart = ISO8601DateFormatter().string(from: Date())
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        let encodedEnd = ISO8601DateFormatter().string(
            from: Date().advanced(by: 86400)
        ).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        let endpoint =
            "https://involved.towson.edu/api/discovery/event/search? startsAfter=\(encodedStart!)endsBefore=\(encodedEnd!)"
        AF.request(endpoint).responseDecodable(of: InvolvedEvents.self) {
            response in
            switch response.result {
            case .success(let data):
                self.events.append(data.value.compactMap {
                    $0.transformToEvent()
                })
            case .failure(let err):
                print(err)
            }
        }
    }

    private func fetchEvents() {

    }
}
