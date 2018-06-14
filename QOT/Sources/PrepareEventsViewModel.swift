//
//  PrepareTripsViewModel.swift
//  QOT
//
//  Created by karmic on 28/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import EventKit

final class PrepareEventsViewModel {

    private let events: [CalendarEvent]

    let preparationTitle: String

    init(preparationTitle: String, events: [CalendarEvent]) {
        self.preparationTitle = preparationTitle
        self.events = events.sorted(by: {
             $0.startDate > $1.startDate
        })
    }

    var eventCount: Int {
        return events.count
    }

    func event(index: Index) -> CalendarEvent {
        return events[index]
    }
}
