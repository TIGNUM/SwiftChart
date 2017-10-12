//
//  EKEventStore+Setting.swift
//  QOT
//
//  Created by Sam Wyndham on 03.08.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import EventKit

struct CalendarSyncSetting {

    let identifier: String
    let title: String
    let syncEnabled: Bool
}

extension EKEventStore {

    static var shared = EKEventStore()

    var syncEnabledCalendars: [EKCalendar] {
        return calendars(for: .event).filter(syncEnabled)
    }

    var calendarSyncSettings: [CalendarSyncSetting] {
        return calendars(for: .event).map { (calendar) in
            return CalendarSyncSetting(identifier: calendar.calendarIdentifier,
                                       title: calendar.title,
                                       syncEnabled: syncEnabled(for: calendar))
        }
    }

    func setSyncEnabled(enabled: Bool, calendarIdentifier: String) {
        var dict: [String: Bool] = UserDefault.calendarDictionary.object as? [String: Bool] ?? [:]
        dict[calendarIdentifier] = enabled
        UserDefault.calendarDictionary.setObject(dict)
    }

    private func syncEnabled(for calendar: EKCalendar) -> Bool {
        let isDefaultCalendar = calendar.calendarIdentifier == defaultCalendarForNewEvents?.calendarIdentifier

        if let dict = UserDefault.calendarDictionary.object as? [String: Bool],
            let enabled = dict[calendar.calendarIdentifier] {
            return enabled
        }

        return isDefaultCalendar ? true : false
    }

    func event(with calendarEvent: CalendarEvent) -> EKEvent? {
        let startDate = calendarEvent.startDate
        let endDate = calendarEvent.endDate
        let predicate = predicateForEvents(withStart: startDate, end: endDate, calendars: syncEnabledCalendars)
        var event: EKEvent?
        enumerateEvents(matching: predicate) { (ekEvent, stop) in
            if calendarEvent.matches(event: ekEvent) {
                event = ekEvent
                stop.pointee = true
            }
        }
        return event
    }
}
