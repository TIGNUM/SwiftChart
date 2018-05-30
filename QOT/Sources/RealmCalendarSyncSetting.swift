//
//  RealmCalendarSyncSetting.swift
//  QOT
//
//  Created by Sam Wyndham on 16/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy

final class RealmCalendarSyncSetting: SyncableObject {

    @objc dynamic var title: String = ""

    @objc dynamic var syncEnabled: Bool = false

    @objc dynamic var changeStamp: String? = UUID().uuidString

    @objc dynamic var deleted: Bool = false

    convenience init(calendarIdentifier: String, title: String, syncEnabled: Bool) {
        self.init()
        self.localID = calendarIdentifier
        self.title = title
        self.syncEnabled = syncEnabled
    }
}

// MARK: - TwoWaySyncable

extension RealmCalendarSyncSetting: TwoWaySyncable {

    static func object(remoteID: Int, store: ObjectStore, data: RealmCalendarSyncSettingIntermediary) -> RealmCalendarSyncSetting? {
        let calendarID = data.calendarIdentifier
        let obj = store.object(ofType: RealmCalendarSyncSetting.self, forPrimaryKey: calendarID)
        if obj == nil {
            return nil
        }
        obj!.setRemoteIDValue(remoteID)
        do {
            try obj?.setData(data, objectStore: store)
        } catch {
            // Do nothing
        }
        return obj
    }

    static func object(remoteID: Int, store: ObjectStore, data: RealmCalendarSyncSettingIntermediary, createdAt: Date, modifiedAt: Date) -> RealmCalendarSyncSetting? {
        let calendarID = data.calendarIdentifier
        let new = RealmCalendarSyncSetting(calendarIdentifier: calendarID, title: data.title, syncEnabled: data.syncEnabled)
        new.modifiedAt = modifiedAt
        new.createdAt = createdAt
        new.setRemoteIDValue(remoteID)
        store.addObject(new)
        return new
    }

    func setData(_ data: RealmCalendarSyncSettingIntermediary, objectStore: ObjectStore) throws {
        title = data.title
        syncEnabled = data.syncEnabled
    }

    static var endpoint: Endpoint {
        return .calendarSettingSync
    }

    func toJson() -> JSON? {
        guard syncStatus != .clean else { return nil }
        let dateFormatter = DateFormatter.iso8601
        var dict: [JsonKey: JSONEncodable] = [
            .id: remoteID.value.toJSONEncodable,
            .createdAt: dateFormatter.string(from: createdAt),
            .modifiedAt: dateFormatter.string(from: modifiedAt),
            .calendarId: localID,
            .title: title,
            .qotId: localID
        ]
        if remoteID.value != nil {
            // Only send this if we have already downsynced this item to avoid resetting values on login
            dict[.syncEnabled] = syncEnabled
        }
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }
}
