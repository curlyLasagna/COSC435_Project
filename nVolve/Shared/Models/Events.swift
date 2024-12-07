import SwiftUICore

struct EventModel: Identifiable {
    let id: String
    let eventName: String
    let eventDescription: String
    let eventLocation: String
    let eventImage: String
    let theme: [String]
    let perks: [String]
    let lat: String
    let long: String
    let time: String
}
