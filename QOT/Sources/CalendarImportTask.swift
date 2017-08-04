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

final class CalendarImportTask {

    func sync(events: [EKEvent], realm: Realm, store: EKEventStore) -> CalendarImportResult {
        let result: CalendarImportResult
        do {
            try realm.write {
                createOrUpdateCalendarEvents(with: events, realm: realm)
                deleteCalendarEventsNotInSyncEnabledCalendarsOrThatReferenceDeletedEKEvents(in: realm, store: store)
            }
            result = .success
        } catch let error {
            result = .failure(error)
        }
        return result
    }

    // MARK: Private

    func createOrUpdateCalendarEvents(with ekEvents: [EKEvent], realm: Realm) {
        for ekEvent in ekEvents {
            if let existingCalendarEvent = realm.syncableObject(ofType: CalendarEvent.self, localID: ekEvent.eventIdentifier) {
                if let modifiedAt = ekEvent.lastModifiedDate, modifiedAt > existingCalendarEvent.ekEventModifiedAt {
                    existingCalendarEvent.update(event: ekEvent)
                }

                // The event might have been soft deleted before so un delete it
                existingCalendarEvent.deleted = false
            } else {
                let new = CalendarEvent(event: ekEvent)
                realm.add(new)
            }
        }
    }

    func deleteCalendarEventsNotInSyncEnabledCalendarsOrThatReferenceDeletedEKEvents(in realm: Realm, store: EKEventStore) {
        let enabledCalendars = store.syncEnabledCalendars
        let calendarEvents = realm.objects(CalendarEvent.self).filter(.deleted(false)).filter { (calendarEvent) -> Bool in
            if let ekEvent = store.event(withIdentifier: calendarEvent.eventID) {
                return enabledCalendars.contains(ekEvent.calendar) == false
            }
            return true
        }
        calendarEvents.forEach { $0.deleteOrMarkDeleted() }
    }
}
