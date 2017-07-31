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

final class CalendarEvent: Object, UpSyncableWithLocalAndRemoteIDs {

    let remoteID = RealmOptional<Int>(nil)

    private(set) dynamic var localID: String = ""

    dynamic var deleted: Bool = false

    private(set) dynamic var createdAt: Date = Date()

    private(set) dynamic var modifiedAt: Date = Date()

    dynamic var localChangeID: String? = UUID().uuidString

    override class func primaryKey() -> String? {
        return "localID"
    }

    convenience init(event: EKEvent) {
        self.init()

        let now = Date()
        self.createdAt = event.creationDate ?? now
        self.modifiedAt = event.lastModifiedDate ?? now
        self.localID = event.eventIdentifier
    }

    func update(event: EKEvent) {
        let now = Date()

        self.modifiedAt = event.lastModifiedDate ?? now
        self.dirty = true
        self.deleted = false
    }

    override func delete() {
        if let realm = realm {
            if existsOnServer == false {
                realm.delete(self)
            } else {
                deleted = true
                dirty = true
            }
        }
    }

    func toJson() -> JSON? {
        if let event = eventStore.event(withIdentifier: eventID) {
            return event.toJSON(id: remoteID.value, createdAt: createdAt, modifiedAt: modifiedAt, syncStatus: syncStatus.rawValue, eventID: eventID)
        } else if syncStatus == .deleted, let remoteID = remoteID.value {
            let dict: [JsonKey: JSONEncodable] = [.id: remoteID, .syncStatus: syncStatus.rawValue]
            return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
        } else {
            return nil
        }
    }

    var eventID: String {
        return localID
    }

    static var endpoint: Endpoint {
        return .calendarEvent
    }
}

private let eventStore = EKEventStore()
