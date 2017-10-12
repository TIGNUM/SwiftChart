//
//  CalendarEvent.swift
//  QOT
//
//  Created by Sam Wyndham on 14/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.CalendarImportManger//

import Foundation
import RealmSwift
import EventKit
import Freddy

final class CalendarEvent: SyncableObject, UpSyncableWithLocalAndRemoteIDs {

    @objc dynamic var deleted: Bool = false

    @objc dynamic var changeStamp: String? = UUID().uuidString
    
    @objc dynamic var ekEventModifiedAt: Date = Date()

    @objc dynamic var title: String = ""

    @objc dynamic var startDate: Date = Date()

    @objc dynamic var endDate: Date = Date()

    var event: EKEvent? {
        return EKEventStore.shared.event(with: self)
    }
    
    convenience init(event: EKEvent) {
        self.init()

        let now = Date()
        self.createdAt = event.creationDate ?? now
        self.modifiedAt = event.lastModifiedDate ?? now
        self.ekEventModifiedAt = event.lastModifiedDate ?? now
        self.title = event.title
        self.startDate = event.startDate
        self.endDate = event.endDate
    }

    func update(event: EKEvent) {
        let now = Date()

        self.modifiedAt = event.lastModifiedDate ?? now
        self.ekEventModifiedAt = event.lastModifiedDate ?? now
        self.dirty = true
        self.deleted = false
    }

    func delete() {
        if let realm = realm {
            if existsOnServer == false {
                realm.delete(self)
            } else {
                deleted = true
                dirty = true
            }
        }
    }

    func deleteOrMarkDeleted() {
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
        if let event = event {
            return event.toJSON(id: remoteID.value, createdAt: createdAt, modifiedAt: modifiedAt, syncStatus: syncStatus.rawValue, localID: localID)
        } else if syncStatus == .deletedLocally, let remoteID = remoteID.value {
            let dict: [JsonKey: JSONEncodable] = [.id: remoteID, .syncStatus: syncStatus.rawValue]
            return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
        } else {
            return nil
        }
    }

    static var endpoint: Endpoint {
        return .calendarEvent
    }

    func matches(event: EKEvent) -> Bool {
        return title == event.title && startDate == event.startDate && endDate == event.endDate
    }
}
