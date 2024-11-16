//
//  EventViewModel.swift
//  nVolve
//
//  Created by Luis on 11/12/24.
//

import UIKit
import Alamofire

@Observable class EventViewModel {
    var events: [InvolvedEvents] = []
    func fetchTodayEvents() {
        AF.request()
    }
    
    func fetchEventsByPerks() {
        
    }
    
    func fetchEventsByTheme() {
        
    }
}
