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
    let eventStore = EKEventStore.shared

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }

    func ekEvents(from: Date, to: Date) -> [EKEvent] {
        let predicate = eventStore.predicateForEvents(withStart: from, end: to, calendars: eventStore.syncEnabledCalendars)
        return eventStore.events(matching: predicate)
    }
}
