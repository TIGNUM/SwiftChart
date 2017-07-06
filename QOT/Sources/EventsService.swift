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

    fileprivate let mainRealm: Realm
    fileprivate let realmProvider: RealmProvider

    let eventStore: EKEventStore

    init(mainRealm: Realm, realmProvider: RealmProvider, eventStore: EKEventStore = EKEventStore()) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
        self.eventStore = eventStore
    }

    func ekEvents(from: Date, to: Date) -> [EKEvent] {
        let predicate = eventStore.predicateForEvents(withStart: from, end: to, calendars: nil)
        return eventStore.events(matching: predicate)
    }
}
