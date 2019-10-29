//
//  EKEvent+Convenience.swift
//  QOT
//
//  Created by karmic on 17.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import EventKit
import qot_dal

extension EKEventStore {

    static var shared = EKEventStore()

    func event(with qdmCalendarEvent: QDMUserCalendarEvent) -> EKEvent? {
        guard
            let startDate = qdmCalendarEvent.startDate,
            let endDate = qdmCalendarEvent.endDate else { return nil }
        let externalIdentifier = qdmCalendarEvent.calendarItemExternalId?.components(separatedBy: "[//]").first
        return getEvent(startDate: startDate, endDate: endDate, identifier: externalIdentifier)
    }

    func getEvent(startDate: Date, endDate: Date, identifier: String?) -> EKEvent? {
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
            if let tmpIdentifier = identifier, tmpIdentifier == ekEvent.calendarItemExternalIdentifier &&
                startDate == ekEvent.startDate {
                event = ekEvent
                stop.pointee = true
            }
        }
        return event
    }

}
