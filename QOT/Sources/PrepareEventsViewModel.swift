//
//  PrepareTripsViewModel.swift
//  QOT
//
//  Created by karmic on 28/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class PrepareEventsViewModel {

    struct Event {
        let eventIdentifier: String
        let title: String
        let startDate: Date
        let endDate: Date
    }

    private let events: [Event]

    let preparationTitle: String

    init(preparationTitle: String, events: [Event]) {
        self.preparationTitle = preparationTitle
        self.events = events
    }

    var eventCount: Int {
        return events.count
    }

    func event(index: Index) -> Event {
        return events[index]
    }
}

extension PrepareEventsViewModel {

    static var mock: PrepareEventsViewModel {
        let events: [Event] = ["Meeting at Novartis", "Meeting with NOS", "Presenetation at DB"].map { (title) -> Event in
            return Event(eventIdentifier: UUID().uuidString, title: title, startDate: Date(), endDate: Date())
        }
        return PrepareEventsViewModel(preparationTitle: "My Negotiation Prep // 23.04.17", events: events)
    }
}
