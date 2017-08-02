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

    fileprivate dynamic var _value: SettingValueObject?

    fileprivate(set) dynamic var sortOrder: Int = 0

    fileprivate(set) dynamic var type: String = ""

    fileprivate(set) dynamic var component: String = ""

    fileprivate(set) dynamic var key: String = ""

    fileprivate(set) dynamic var displayName: String = ""

    fileprivate(set) dynamic var settingDescription: String = ""

    fileprivate(set) dynamic var pageIDs: String = ""

    fileprivate(set) dynamic var isDefault: Bool = true

    var value: SettingValue {
        guard let value = _value else {
            return .invalid
        }
        return SettingValue(setting: value)
    }
}

extension SystemSetting: DownSyncable {

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
