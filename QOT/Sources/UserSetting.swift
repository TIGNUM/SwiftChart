//
//  UserSetting.swift
//  QOT
//
//  Created by Sam Wyndham on 11.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy

final class UserSetting: SyncableObject {

    fileprivate dynamic var _value: SettingValueObject?

    dynamic var changeStamp: String? = UUID().uuidString

    var value: SettingValue {
        get {
            guard let value = _value else {
                return .invalid
            }
            return SettingValue(setting: value)
        }
        set {
            _value?.delete()
            _value = SettingValueObject(with: newValue)
            didUpdate()
        }
    }

    convenience init(with value: SettingValue) {
        self.init()

        self.value = value
    }
}

extension UserSetting: TwoWaySyncableWithUpdateOnlyUpsyncing {

    static var endpoint: Endpoint {
        return .userSetting
    }

    func setData(_ data: UserSettingIntermediary, objectStore: ObjectStore) throws {
        _value?.delete()
        _value = SettingValueObject(with: data.value)

        dirty = false
    }

    func toJson() -> JSON? {
        guard let value = _value, let settingID = remoteID.value else {
            return nil
        }

        return SettingValue(setting: value).toJSON(settingID: settingID)
    }
}
