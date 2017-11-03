//
//  Setting.swift
//  QOT
//
//  Created by Sam Wyndham on 07.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class SystemSetting: SyncableObject {

    @objc private dynamic var _value: SettingValueObject?

    @objc private(set) dynamic var sortOrder: Int = 0

    @objc private(set) dynamic var type: String = ""

    @objc private(set) dynamic var component: String = ""

    @objc private(set) dynamic var key: String = ""

    @objc private(set) dynamic var displayName: String = ""

    @objc private(set) dynamic var settingDescription: String = ""

    @objc private(set) dynamic var pageIDs: String = ""

    @objc private(set) dynamic var isDefault: Bool = true

    var value: SettingValue {
        guard let value = _value else {
            return .invalid
        }
        return SettingValue(setting: value)
    }
}

extension SystemSetting: OneWaySyncableDown {

    static var endpoint: Endpoint {
        return .systemSetting
    }

    func setData(_ data: SystemSettingIntermediary, objectStore: ObjectStore) throws {
        sortOrder = data.sortOrder
        type = data.type
        component = data.component
        key = data.key
        displayName = data.displayName
        settingDescription = data.settingDescription
        pageIDs = data.pageIDs
        isDefault = data.isDefault
        _value?.delete()
        _value = SettingValueObject(with: data.value)
    }
}
