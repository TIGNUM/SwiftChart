//
//  CalendarEvent.swift
//  QOT
//
//  Created by Sam Wyndham on 14/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.

import Foundation
import RealmSwift
import EventKit
import Freddy

final class CalendarEvent: SyncableObject {

    @objc dynamic var deleted: Bool = false

    @objc dynamic var changeStamp: String? = UUID().uuidString

    @objc dynamic var ekEventModifiedAt: Date = Date()

    @objc dynamic var title: String?

    @objc dynamic var startDate: Date = Date()

    @objc dynamic var endDate: Date = Date()

    @objc dynamic var calendarItemExternalIdentifier: String?

    @objc dynamic var calendarIdentifier: String?

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
        self.calendarItemExternalIdentifier = event.calendarItemExternalIdentifier
        self.calendarIdentifier = event.calendar.toggleIdentifier
    }

    func update(event: EKEvent) {
        let now = Date()
        self.title = event.title
        self.startDate = event.startDate
        self.endDate = event.endDate
        self.modifiedAt = event.lastModifiedDate ?? now
        self.ekEventModifiedAt = event.lastModifiedDate ?? now
        self.calendarItemExternalIdentifier = event.calendarItemExternalIdentifier
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

    func matches(event: EKEvent) -> Bool {
        return event.calendarItemExternalIdentifier == calendarItemExternalIdentifier && event.startDate == startDate
    }
}

// MARK: - TwoWaySyncable

extension CalendarEvent: TwoWaySyncable {

    static func object(remoteID: Int, store: ObjectStore, data: CalendarEventIntermediary) -> CalendarEvent? {
        let startDate: Date

        if let milliseconds = Double(data.startDateString) {
            startDate = Date.init(milliseconds: milliseconds)
        } else {
            startDate = Date(timeIntervalSince1970: 0)
        }

        let objs = store.objects(CalendarEvent.self).filter("remoteID == %d", remoteID)
        var obj = objs.first

        if obj == nil {
            obj = store.objects(CalendarEvent.self).filter("remoteID == nil && calendarItemExternalIdentifier == %@ && startDate == %@",
                                                           data.calendarItemExternalIdentifier, startDate).first
        } else {
            do {
                try obj?.setData(data, objectStore: store)
                obj?.setRemoteIDValue(remoteID)
            } catch {
                // Do nothing
            }
        }
        return obj
    }

    static func object(remoteID: Int, store: ObjectStore, data: CalendarEventIntermediary, createdAt: Date, modifiedAt: Date) -> CalendarEvent? {
        let new = CalendarEvent()
        do {
            try new.setData(data, objectStore: store)
        } catch {
            // Do nothing
        }
        new.modifiedAt = modifiedAt
        new.createdAt = createdAt
        new.setRemoteIDValue(remoteID)
        store.addObject(new)
        return new
    }

    func setData(_ data: CalendarEventIntermediary, objectStore: ObjectStore) throws {
        deleted = data.deleted
        title = data.title
        calendarItemExternalIdentifier = data.calendarItemExternalIdentifier
        calendarIdentifier = data.calendarIdentifier

        if let milliseconds = Double(data.startDateString) {
            startDate = Date.init(milliseconds: milliseconds)
        }
        if let milliseconds = Double(data.endDateString) {
            endDate = Date.init(milliseconds: milliseconds)
        }
    }

    func toJson() -> JSON? {
        if let event = event {
            return event.toJSON(id: remoteID.value,
                                createdAt: createdAt,
                                modifiedAt: modifiedAt,
                                syncStatus: syncStatus.rawValue,
                                localID: localID)
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
}
