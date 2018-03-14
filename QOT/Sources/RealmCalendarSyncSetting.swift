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
