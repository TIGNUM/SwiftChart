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

    func sync(calendars: [EKCalendar]) -> CalendarImportResult {
        let events: [EKEvent]
        let syncableCalendars: [EKCalendar]
        if calendars.count == 0 {
            events = []
            syncableCalendars = store.calendars(for: .event)
        } else {
            // @warning: if calendars.count == 0 predicate will search all calendars hence the above check.
            let predicate = store.predicateForEvents(withStart: start, end: end, calendars: calendars)
            events = store.events(matching: predicate)
            syncableCalendars = calendars
        }

        let syncableCalendarIdentifiers: [String] = syncableCalendars.compactMap {
            String($0.toggleIdentifier)
        }

        let result: CalendarImportResult
        do {
            let existingCalendarEvents: Results<CalendarEvent> = realm.objects()
            try realm.write {
                createOrUpdateCalendarEvents(with: events, realm: realm, with: syncableCalendarIdentifiers)
                deleteCalendarEvents(from: Array(existingCalendarEvents), using: events, with: syncableCalendarIdentifiers)
                deleteDuplicatedCalendarEvents(with: events, realm: realm)
            }
            result = .success
        } catch {
            result = .failure(error)
        }
        return result
    }

    // MARK: Private

    private func createOrUpdateCalendarEvents(with ekEvents: [EKEvent], realm: Realm, with syncableCalendarIdentifiers: [String]) {
        for ekEvent in ekEvents {
            if syncableCalendarIdentifiers.contains(obj: ekEvent.calendar.toggleIdentifier) == false {
                return
            }
            let existingCalendarEvent = realm.objects(CalendarEvent.self).filter(externalIdentifier: ekEvent.calendarItemExternalIdentifier).first

            if let existing = existingCalendarEvent {
                ekEvent.refresh()
                if let modifiedAt = ekEvent.lastModifiedDate, modifiedAt > existing.ekEventModifiedAt {
                    existing.update(event: ekEvent)
                }
                // The event might have been soft deleted before so un delete it
                existing.deleted = false
            } else {
                let new = CalendarEvent(event: ekEvent)
                realm.add(new)
            }
        }
    }

    private func deleteDuplicatedCalendarEvents(with ekEvents: [EKEvent], realm: Realm) {
        var handledExternalIdentifiers = [String]()
        for ekEvent in ekEvents {
            if handledExternalIdentifiers.contains(obj: ekEvent.calendarItemExternalIdentifier) { continue }

            let existingEvents = realm.objects(CalendarEvent.self).filter(externalIdentifier: ekEvent.calendarItemExternalIdentifier)

            if existingEvents.count > 1 {
                handledExternalIdentifiers.append(ekEvent.calendarItemExternalIdentifier)
                let duplicatedEvents = existingEvents[1...(existingEvents.count - 1)]
                for duplicatedEntity in duplicatedEvents {
                    duplicatedEntity.deleteOrMarkDeleted()
                }
            }
        }
    }

    private func deleteCalendarEvents(from calendarEvents: [CalendarEvent], using ekEvents: [EKEvent], with syncableCalendarIdentifiers: [String]) {
        let relevantCalendarEvents = calendarEvents.filter {
            if $0.deleted { return false } // if it's already checked to delete, do nothing.
            if $0.calendarItemExternalIdentifier == nil { return true }

            // sync for the calendar of event is not allowed. do not delete
            if let toggleIdentifier = $0.event?.calendar.toggleIdentifier, syncableCalendarIdentifiers.contains(obj: toggleIdentifier) == false {
                return false
            } else if $0.endDate <= start {
                return true
            } else if $0.startDate >= end {
                return true
            } else if $0.calendarItemExternalIdentifier?.isEmpty == false {
                let matchedEvent = store.calendarItems(withExternalIdentifier: $0.calendarItemExternalIdentifier!).first
                return matchedEvent == nil ? true : false
            }
            return false
        }
        for calendarEvent in relevantCalendarEvents {
            if ekEvents.contains(where: { calendarEvent.matches(event: $0) }) == false {
                calendarEvent.deleteOrMarkDeleted()
            }
        }
    }
}
