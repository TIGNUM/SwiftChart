//
//  CalendarEvent.swift
//  QOT
//
//  Created by Sam Wyndham on 14/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import EventKit
import Freddy

final class CalendarEvent: Object {

    let remoteID = RealmOptional<Int>(nil)

    private(set) dynamic var deleted: Bool = false

    private(set) dynamic var dirty: Bool = true

    private(set) dynamic var createdAt: Date = Date()

    private(set) dynamic var modifiedAt: Date = Date()

    private(set) dynamic var eventID: String = ""

    override class func primaryKey() -> String? {
        return "eventID"
    }

    convenience init(event: EKEvent) {
        self.init()

        let now = Date()
        self.createdAt = event.creationDate ?? now
        self.modifiedAt = event.lastModifiedDate ?? now
        self.eventID = event.eventIdentifier
    }

    func update(event: EKEvent) {
        let now = Date()

        self.modifiedAt = event.lastModifiedDate ?? now
        self.dirty = true
        self.deleted = false
    }

    func delete() {
        self.deleted = true
    }

    func json(eventStore: EKEventStore) -> JSON? {
        guard let event = eventStore.event(withIdentifier: eventID) else {
            return nil
        }
        return event.toJSON(id: remoteID.value, createdAt: createdAt, modifiedAt: modifiedAt, syncStatus: syncStatus.rawValue, eventID: eventID)
    }

    var syncStatus: UpSyncStatus {
        if !dirty {
            return .clean
        } else if deleted {
            return .deleted
        } else if remoteID.value == nil {
            return .created
        } else {
            return .updated
        }
    }

    func setRemoteID(_ id: Int) {
        remoteID.value = id
        dirty = false
    }
}

enum UpSyncStatus: Int {
    case clean = -1
    case created = 0
    case updated = 1
    case deleted = 2
}
