//
//  UserSetting.swift
//  QOT
//
//  Created by Sam Wyndham on 11.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class UserSetting: SyncableObject {

    fileprivate dynamic var _value: SettingValueObject?

    fileprivate(set) dynamic var dirty: Bool = true

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
            dirty = true
        }
    }

    convenience init(with value: SettingValue) {
        self.init()

        self.value = value
    }
}

extension UserSetting: OneWaySyncableDown {

    static var endpoint: Endpoint {
        return .userSetting
    }

    func setData(_ data: UserSettingIntermediary, objectStore: ObjectStore) throws {
        dirty = false

        _value?.delete()
        _value = SettingValueObject(with: data.value)
    }
}
