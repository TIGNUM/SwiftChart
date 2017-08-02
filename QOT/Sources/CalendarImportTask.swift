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
    func sync(events: [EKEvent], realm: Realm, store: EKEventStore) -> CalendarImportResult {
        let markDeleted = fetchEventsNeedingDeletion(in: realm, store: store)
        
        let result: CalendarImportResult
        do {
            try realm.write {
                markDeleted.forEach { $0.delete() }
                
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
    private func sync(event: EKEvent, realm: Realm) {
        if let existing = realm.syncableObject(ofType: CalendarEvent.self, localID: event.eventIdentifier) {
            if let modifiedAt = event.lastModifiedDate, modifiedAt > existing.modifiedAt {
                existing.update(event: event)
            }
        } else {
            // Create the event.
            let new = CalendarEvent(event: event)
            realm.add(new)
        }
    }
    
    private func fetchEventsNeedingDeletion(in realm: Realm, store: EKEventStore) -> [CalendarEvent] {
        return realm.objects(CalendarEvent.self)
            .filter("deleted == false")
            .filter { store.event(withIdentifier: $0.eventID) == nil }
    }
}
