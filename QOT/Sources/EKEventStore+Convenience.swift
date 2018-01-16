//
//  EKEventStore+Setting.swift
//  QOT
//
//  Created by Sam Wyndham on 03.08.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import EventKit

extension EKEventStore {

    static var shared = EKEventStore()

    func event(with calendarEvent: CalendarEvent) -> EKEvent? {
        let title = calendarEvent.title
        let startDate = calendarEvent.startDate
        let endDate = calendarEvent.endDate
        let predicate = predicateForEvents(withStart: startDate - TimeInterval(days: 1),
                                           end: endDate + TimeInterval(days: 1),
                                           calendars: nil)
        var event: EKEvent?
        enumerateEvents(matching: predicate) { (ekEvent, stop) in
            /*
             @warning do not use `calendarEvent.matches(event: EKEvent) -> Bool`
             enumerateEvents(...) runs this block on the main thread, which can cause issues the CalendarEvent is from a
             Realm initialised on another thread (e.g. background thread from sync)
             */
            if title == ekEvent.title && startDate == ekEvent.startDate && endDate == ekEvent.endDate {
                event = ekEvent
                stop.pointee = true
            }
        }
        return event
    }
}
