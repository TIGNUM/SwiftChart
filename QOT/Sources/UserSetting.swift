//
//  UserSetting.swift
//  QOT
//
//  Created by Sam Wyndham on 11.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class UserSetting: Object {

    fileprivate dynamic var _value: SettingValueObject?

    fileprivate(set) dynamic var remoteID: Int = 0

    dynamic var createdAt: Date = Date()

    dynamic var modifiedAt: Date = Date()

    fileprivate(set) dynamic var dirty: Bool = true

    fileprivate(set) dynamic var format: String = ""

    var value: SettingValue {
        get {
            guard let format = SettingFormat(rawValue: format), let value = _value else {
                return .invalid
            }
            return SettingValue(setting: value, format: format)
        }
        set {
            _value?.delete()
            _value = SettingValueObject(value: newValue)
            dirty = true
        }
    }

    override class func primaryKey() -> String? {
        return "remoteID"
    }
}

extension UserSetting: DownSyncable {

    static func make(remoteID: Int, createdAt: Date) -> UserSetting {
        let setting = UserSetting()
        setting.remoteID = remoteID
        setting.createdAt = createdAt
        return setting
    }

    func setData(_ data: UserSettingIntermediary, objectStore: ObjectStore) throws {
        format = data.format
        dirty = false

        _value?.delete()
        _value = SettingValueObject(value: data.value)
    }
}
