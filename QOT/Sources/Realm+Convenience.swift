//
//  Realm+Convenience.swift
//  QOT
//
//  Created by Sam Wyndham on 21.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {

    func dirtyCalandarEvents() -> Results<CalendarEvent> {
        return objects(predicate: NSPredicate(dirty: true))
    }

    func setCalendarEventRemoteIDs(remoteIDs: LocalIDToRemoteIDMap) {
        let predicate = NSPredicate(eventIDs: Array(remoteIDs.keys))
        let events: Results<CalendarEvent> = objects(predicate: predicate)
        for event in events {
            event.remoteID.value = remoteIDs[event.eventID]
        }
    }

    private func objects<T>(predicate: NSPredicate? = nil) -> Results<T> {
        if let predicate = predicate {
            return objects(T.self).filter(predicate)
        } else {
            return objects(T.self)
        }
    }
}
