//
//  nVolveApp.swift
//  nVolve
//
//  Created by Luis on 10/10/24.
//

import SwiftUI

@main
struct nVolveApp: App {
    init() {
        NotificationsManager.shared.requestNotificationPermission()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
