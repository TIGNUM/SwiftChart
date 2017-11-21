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
import Crashlytics

final class CalendarImportTask {

    let start: Date
    let end: Date
    let realm: Realm
    let store: EKEventStore

    init(startDate: Date, endDate: Date, realm: Realm, store: EKEventStore) {
        self.start = startDate
        self.end = endDate
        self.realm = realm
        self.store = store
    }

    func sync() -> CalendarImportResult {
        let predicate = store.predicateForEvents(withStart: start, end: end, calendars: store.syncEnabledCalendars)
        let events = store.events(matching: predicate)
        let result: CalendarImportResult
        do {
            let existingCalendarEvents: Results<CalendarEvent> = realm.objects()
            try realm.write {
                createOrUpdateCalendarEvents(with: events, realm: realm)
                deleteCalendarEvents(from: Array(existingCalendarEvents), using: events)
            }
            result = .success
        } catch {
            result = .failure(error)
        }
        return result
    }

    // MARK: Private

    private func createOrUpdateCalendarEvents(with ekEvents: [EKEvent], realm: Realm) {
        for ekEvent in ekEvents {
            CLSLogv("Log createOrUpdateCalendarEvents - ekEvent.title %@", getVaList([ekEvent.title]))
            CLSLogv("Log createOrUpdateCalendarEvents - ekEvent.startDate %@", getVaList([ekEvent.startDate.description]))
            CLSLogv("Log createOrUpdateCalendarEvents - ekEvent.endDate %@", getVaList([ekEvent.endDate.description]))
            
            let predicate = NSPredicate.calendarEvent(title: ekEvent.title,
                                                      startDate: ekEvent.startDate,
                                                      endDate: ekEvent.endDate)
            if let existingCalendarEvent: CalendarEvent = realm.objects(predicate: predicate).first {
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

    private func deleteCalendarEvents(from calendarEvents: [CalendarEvent], using ekEvents: [EKEvent]) {
        let relevantCalendarEvents = calendarEvents.filter {
            return $0.deleted == false && $0.endDate >= start && $0.startDate <= end
        }
        for calendarEvent in relevantCalendarEvents {
            if ekEvents.contains(where: { calendarEvent.matches(event: $0) }) == false {
                calendarEvent.deleteOrMarkDeleted()
            }
        }
    }
}
