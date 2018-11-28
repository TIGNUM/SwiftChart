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

    @objc dynamic var calendarEventItemIdentifierSuffix: String?

    @objc dynamic var calendarIdentifier: String?

    var event: EKEvent? {
        return EKEventStore.shared.getEvent(startDate: self.startDate,
											endDate: self.endDate,
											identifier: self.calendarItemExternalIdentifier)
    }

    var suffixDelemeter: String { return "[//]" }

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
        if self.calendarEventItemIdentifierSuffix == nil {
            setSuffix(with: startDate)
        }
    }

    func setSuffix(with date: Date) {
        self.calendarEventItemIdentifierSuffix = suffixDelemeter + DateFormatter.iso8601.string(from: date)
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
        if self.calendarEventItemIdentifierSuffix == nil {
            setSuffix(with: startDate)
        }
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
        // if it's not same day : it's not same event
        if startDate.isSameDay(event.startDate) == false {
            return false
        }
        // if same calendar item
        if event.calendarItemExternalIdentifier ==  calendarItemExternalIdentifier {
            return true
        }

        // or same identifier prefix (because of /RIDXXXXXX postfix when event changed)
        if let storedExternalIdentifier = calendarItemExternalIdentifier {
            let storedPrefix = storedExternalIdentifier.components(separatedBy: "/RID").first ?? "CalendarEvent"
            let eventPrefix = event.calendarItemExternalIdentifier.components(separatedBy: "/RID").first ?? "EkEvent"
            return storedPrefix == eventPrefix
        }
        return false
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
        }
        do {
            try obj?.setData(data, objectStore: store)
            obj?.setRemoteIDValue(remoteID)
        } catch {
            log("error to set CalendarEvent Data and RemoteID : \(error)", level: .error)
        }
        return obj
    }

    static func object(remoteID: Int, store: ObjectStore, data: CalendarEventIntermediary, createdAt: Date, modifiedAt: Date) -> CalendarEvent? {
        // Try to Create calendar event which is not exising in DB yet.
        if data.syncStatus == 2 { // if it's deleted
            return nil
        }
        let new = CalendarEvent()
        do {
            try new.setData(data, objectStore: store)
        } catch {
            log("error to create new CalendarEvent : \(error)", level: .error)
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

        if let milliseconds = Double(data.startDateString) {
            startDate = Date.init(milliseconds: milliseconds)
        }
        if let milliseconds = Double(data.endDateString) {
            endDate = Date.init(milliseconds: milliseconds)
        }

        calendarIdentifier = data.calendarIdentifier

        if let range = data.calendarItemExternalIdentifier.range(of: suffixDelemeter) {
            calendarItemExternalIdentifier = String(data.calendarItemExternalIdentifier[..<range.lowerBound])
            calendarEventItemIdentifierSuffix = String(data.calendarItemExternalIdentifier[range.lowerBound...])
        } else {
            calendarItemExternalIdentifier = data.calendarItemExternalIdentifier
            setSuffix(with: startDate)
        }
    }

    func toJson() -> JSON? {
        if syncStatus == .deletedLocally, let remoteID = remoteID.value {
            let dict: [JsonKey: JSONEncodable] = [.id: remoteID, .syncStatus: syncStatus.rawValue]
            return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
        } else if let event = event {
            return event.toJSON(id: remoteID.value,
                                createdAt: createdAt,
                                modifiedAt: modifiedAt,
                                syncStatus: syncStatus.rawValue,
                                localID: localID,
                                externalIdentifierSuffix: calendarEventItemIdentifierSuffix ?? "")
        } else {
            return nil
        }
    }

    static var endpoint: Endpoint {
        return .calendarEvent
    }
}
