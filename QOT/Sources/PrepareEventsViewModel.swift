//
//  PrepareTripsViewModel.swift
//  QOT
//
//  Created by karmic on 28/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import EventKit

final class PrepareEventsViewModel {

    private let events: [CalendarEvent]
    private let calendars: [String]
    let preparationTitle: String

    init(preparationTitle: String, events: [CalendarEvent], calendarIdentifiers: [String]) {
        self.preparationTitle = preparationTitle
        self.events = events
        self.calendars = calendarIdentifiers
    }

    var eventCount: Int {
        return events.count
    }

    var availableCalendarCount: Int {
        return calendars.count
    }

    func event(index: Index) -> CalendarEvent {
        return events[index]
    }
}
