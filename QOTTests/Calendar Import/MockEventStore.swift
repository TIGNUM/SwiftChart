//
//  MockEventStore.swift
//  QOT
//
//  Created by Sam Wyndham on 17/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
@testable import QOT

class MockEventStore: EventStore {
    private var events: [String: CalendarEventData] = [:]
    
    init(events: [CalendarEventData] = []) {
        events.forEach { (event) in
            self.events[event.id] = event
        }
    }
    
    func event(identifier: String) -> CalendarEventData? {
        return events[identifier]
    }
    
    func addEvent(_ event: CalendarEventData) {
        events[event.id] = event
    }
}
