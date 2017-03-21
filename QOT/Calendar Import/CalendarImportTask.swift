//
//  CalendarImportTask.swift
//  QOT
//
//  Created by Sam Wyndham on 16/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import EventKit

/// Performs the one-way sync of `EKEvent`'s into `Realm`.
final class CalendarImportTask {
    /// Syncs `events` with `realm`.
    func sync(events: [CalendarEventData], realm: Realm, store: EventStore) -> CalendarImportResult {
        let markDeleted = fetchEventsNeedingDeletion(in: realm, store: store)
        
        let result: CalendarImportResult
        do {
            try realm.write {
                markDeleted.forEach { $0.deleted = true }
                
                for event in events {
                    sync(event: event, realm: realm)
                }
            }
            result = .success
        } catch let error {
            result = .failure(error)
        }
        return result
    }
    
    /// Syncs `event` with `realm`.
    ///
    /// - warning: This method may only be called during a write transaction.
    private func sync(event: CalendarEventData, realm: Realm) {
        if let existing = realm.object(ofType: CalendarEvent.self, forPrimaryKey: event.id) {
            if event.modified > existing.modified {
                // For now we deleting and recreating all attendees on each update. The attendee has no unique
                // identifier and no modified date. Potentially we could treat the attendees URL as a unique identifier
                // and perform an update instead of deletion.
                realm.delete(existing.participants)
                
                // Update the event.
                existing.update(with: event)
            }
        } else {
            // Create the event.
            let new = CalendarEvent(event: event)
            realm.add(new)
        }
    }
    
    private func fetchEventsNeedingDeletion(in realm: Realm, store: EventStore) -> [CalendarEvent] {
        return realm.objects(CalendarEvent.self)
            .filter("deleted == false")
            .filter { store.event(identifier: $0.id) == nil }
    }
}
