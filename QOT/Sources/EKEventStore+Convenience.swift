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
        let startDate = calendarEvent.startDate
        let endDate = calendarEvent.endDate
        let externalIdentifier = calendarEvent.calendarItemExternalIdentifier
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
