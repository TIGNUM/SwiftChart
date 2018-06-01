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
        let existingCalendarIds: [String] = store.calendars(for: .event).compactMap { String($0.toggleIdentifier) }
        if calendars.count == 0 {
            events = []
        } else {
            // @warning: if calendars.count == 0 predicate will search all calendars hence the above check.
            let predicate = store.predicateForEvents(withStart: start, end: end, calendars: calendars)
            events = store.events(matching: predicate)
        }

        let syncableCalendarIds: [String] = calendars.compactMap {
            String($0.toggleIdentifier)
        }

        let result: CalendarImportResult
        do {
            let existingCalendarEvents: Results<CalendarEvent> = realm.objects()
            try realm.write {
                createOrUpdateCalendarEvents(with: events, realm: realm, with: syncableCalendarIds)
                deleteDuplicatedCalendarEvents(with: events, realm: realm)
                deleteCalendarEvents(from: Array(existingCalendarEvents), using: events,
                                     syncableCalendarIds: syncableCalendarIds, existingCalendarIds: existingCalendarIds)
                deleteLegacyCalendarEvents(from: Array(existingCalendarEvents))
            }
            result = .success
        } catch {
            result = .failure(error)
        }
        return result
    }

    // MARK: Private

    private func createOrUpdateCalendarEvents(with ekEvents: [EKEvent], realm: Realm, with syncableCalendarIds: [String]) {
        for ekEvent in ekEvents {
            if syncableCalendarIds.contains(obj: ekEvent.calendar.toggleIdentifier) == false { continue }
            let existingCalendarEvent = realm.objects(CalendarEvent.self).filter(externalIdentifier: ekEvent.calendarItemExternalIdentifier).first

            if let existing = existingCalendarEvent {
                ekEvent.refresh()
                if let modifiedAt = ekEvent.lastModifiedDate,
                    modifiedAt > existing.ekEventModifiedAt ||
                    existing.calendarItemExternalIdentifier == nil || existing.calendarIdentifier == nil {
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
            // if it's already handled, Do nothing
            if handledExternalIdentifiers.contains(obj: ekEvent.calendarItemExternalIdentifier) { continue }

            let existingEvents = realm.objects(CalendarEvent.self).filter(externalIdentifier: ekEvent.calendarItemExternalIdentifier)
            if existingEvents.count > 1 { //if duplcated
                handledExternalIdentifiers.append(ekEvent.calendarItemExternalIdentifier)
                let duplicatedEvents = existingEvents[1...(existingEvents.count - 1)]
                for duplicatedEntity in duplicatedEvents {
                    duplicatedEntity.deleteOrMarkDeleted()
                }
            }
        }
    }

    private func deleteLegacyCalendarEvents(from calendarEvents: [CalendarEvent]) {
        let relevantCalendarEvents = calendarEvents.filter {
            if $0.deleted { return false } // if it's already checked to delete, do nothing.
            if $0.calendarItemExternalIdentifier == nil || $0.calendarIdentifier == nil { return true }
            return false
        }
        for calendarEvent in relevantCalendarEvents {
            calendarEvent.deleteOrMarkDeleted()
        }
    }

    private func deleteCalendarEvents(from calendarEvents: [CalendarEvent], using ekEvents: [EKEvent], syncableCalendarIds: [String], existingCalendarIds: [String]) {
        let relevantCalendarEvents = calendarEvents.filter {
            if $0.deleted { return false } // if it's already checked to delete, do nothing.

            if $0.endDate <= start {
                return true
            } else if $0.startDate >= end {
                return true
            }

            if existingCalendarIds.contains(obj: $0.calendarIdentifier) == false { // event calendar is not existing current device, cannot remove it
                return false
            }

            if syncableCalendarIds.contains(obj: $0.calendarIdentifier) == false { // sync for the calendar of event is disabled, delete it
                return true
            }

            if let externalId = $0.calendarItemExternalIdentifier, externalId.isEmpty == false {
                // event calendar is on this device and syncable.
                let matchedEvent = store.calendarItems(withExternalIdentifier: externalId).first
                // if user deleted the event from calendar, we also need to delete it.
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
