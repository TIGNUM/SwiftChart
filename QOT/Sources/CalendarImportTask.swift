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
            events = store.events(matching: predicate).compactMap { $0 }
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
        let refreshedEvents = Array(Set(ekEvents)) // FIXME: EKEvent should be fetched in main thread. Otherwise recurrence related infos will not be updated

        for ekEvent in refreshedEvents {
            if syncableCalendarIds.contains(obj: ekEvent.calendar.toggleIdentifier) == false { continue } // sync for the calendar of event is disabled, ignore it
            let filteredEvents: [CalendarEvent] = realm.objects(CalendarEvent.self).filter {
                // if same calendar item or same identifier prefix (because of /RIDXXXXXX postfix when event changed)
                let calendarEvent = $0
                return (ekEvent.calendarItemExternalIdentifier ==  calendarEvent.calendarItemExternalIdentifier
                    || ekEvent.calendarItemExternalIdentifier.hasPrefix(calendarEvent.calendarItemExternalIdentifier ?? Toggle.seperator))
            }
            let calendarEvent: CalendarEvent?
            if ekEvent.hasRecurrenceRules == true {
                calendarEvent = filteredEvents.filter {
                    return $0.startDate.isSameDay(ekEvent.startDate)
                    }.first
            } else {
                calendarEvent = filteredEvents.filter {
                    ekEvent.calendarItemExternalIdentifier ==  $0.calendarItemExternalIdentifier
                }.first
            }

            if let existing = calendarEvent {
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

            let existingEvents = realm.objects(CalendarEvent.self).filter(ekEvent: ekEvent)
            if existingEvents.count > 1 { //if duplcated
                handledExternalIdentifiers.append(ekEvent.calendarItemExternalIdentifier)
                var index: Int = 0
                for duplicatedEntity in existingEvents {
                    if index == 0 { continue }
                    duplicatedEntity.deleteOrMarkDeleted()
                    index += 1
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
        let relevantCalendarEvents = calendarEvents.filter({ (calendarEvent) -> Bool in
            if calendarEvent.deleted { return false } // if it's already checked to delete, do nothing.

            if calendarEvent.endDate <= start {
                return true
            } else if calendarEvent.startDate >= end {
                return true
            }

            if existingCalendarIds.contains(obj: calendarEvent.calendarIdentifier) == false { // event's calendar is not existing current device, cannot remove it
                return false
            }

            if syncableCalendarIds.contains(obj: calendarEvent.calendarIdentifier) == false { // sync for the calendar of event is disabled, delete it
                return true
            }

            if let externalId = calendarEvent.calendarItemExternalIdentifier, externalId.isEmpty == false {
                // event's calendar is on this device and syncable.
                let matchedEvent = ekEvents.filter({ (ekEvent) -> Bool in
                    return ekEvent.startDate == calendarEvent.startDate
                }).first

                return matchedEvent == nil ? true : false // if user deleted the event from calendar, we also need to delete it.
            }

            return true // externalId.isEmpty : it's legacy data. need to delete it.
        })
        for calendarEvent in relevantCalendarEvents {
            if ekEvents.contains(where: { calendarEvent.matches(event: $0) }) == false {
                calendarEvent.deleteOrMarkDeleted()
            }
        }
    }
}
