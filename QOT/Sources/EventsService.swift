//
//  EventsService.swift
//  QOT
//
//  Created by Sam Wyndham on 05.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import EventKit

final class EventsService {

    private let mainRealm: Realm
    private let realmProvider: RealmProvider
    private let syncSettingsManager: CalendarSyncSettingsManager
    let eventStore = EKEventStore.shared

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
        self.syncSettingsManager = CalendarSyncSettingsManager(realmProvider: realmProvider)
    }

    func calendarEvents(from: Date, to: Date) -> [CalendarEvent] {
        let existingCalendarEvents: Results<CalendarEvent> = mainRealm.objects()
        let relevantCalendarEvents = existingCalendarEvents.filter {
            if $0.startDate < from && $0.startDate > to {
                return false
            }
            return true
        }
        return Array(relevantCalendarEvents)
    }

    func calendarEvent(remoteID: RealmOptional<Int>?) -> CalendarEvent? {
        let existingCalendarEvents: Results<CalendarEvent> = mainRealm.objects()
        let relevantCalendarEvents = existingCalendarEvents.filter {
            return $0.remoteID.value == remoteID?.value ? true : false
        }
        return Array(relevantCalendarEvents).first
    }

    func calendarEvent(calendarItemExternalIdentifier: String!) -> CalendarEvent? {
        let existingCalendarEvents: Results<CalendarEvent> = mainRealm.objects()
        let relevantCalendarEvents = existingCalendarEvents.filter {
            return $0.calendarItemExternalIdentifier == calendarItemExternalIdentifier ? true : false
        }
        return Array(relevantCalendarEvents).first
    }
}
