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

    func ekEvents(from: Date, to: Date) -> [EKEvent] {
        let predicate = eventStore.predicateForEvents(withStart: from,
                                                      end: to,
                                                      calendars: syncSettingsManager.syncEnabledCalendars)
        return eventStore.events(matching: predicate)
    }
}
