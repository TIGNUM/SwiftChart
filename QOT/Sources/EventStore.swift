//
//  EventStore.swift
//  QOT
//
//  Created by Sam Wyndham on 17/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import EventKit

protocol EventStore {
    /// Returns `CalendarEventData` for `identifier` or nil if none exists.
    func event(identifier: String) -> CalendarEventData?
}

extension EKEventStore: EventStore {
    func event(identifier: String) -> CalendarEventData? {
        return event(withIdentifier: identifier)
    }
}
