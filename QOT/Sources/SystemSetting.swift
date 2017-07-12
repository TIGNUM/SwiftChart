//
//  Setting.swift
//  QOT
//
//  Created by Sam Wyndham on 07.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class SystemSetting: Object {

    fileprivate dynamic var _value: SettingValueObject?

    dynamic var remoteID: Int = 0

    dynamic var createdAt: Date = Date()

    dynamic var modifiedAt: Date = Date()

    fileprivate(set) dynamic var sortOrder: Int = 0

    fileprivate(set) dynamic var type: String = ""

    fileprivate(set) dynamic var component: String = ""

    fileprivate(set) dynamic var format: String = ""

    fileprivate(set) dynamic var key: String = ""

    fileprivate(set) dynamic var displayName: String = ""

    fileprivate(set) dynamic var settingDescription: String = ""

    fileprivate(set) dynamic var pageIDs: String = ""

    fileprivate(set) dynamic var isDefault: Bool = true

    var value: SettingValue {
        guard let format = SettingFormat(rawValue: format), let value = _value else {
            return .invalid
        }
        return SettingValue(setting: value, format: format)
    }

    override class func primaryKey() -> String? {
        return "remoteID"
    }
}

extension SystemSetting: DownSyncable {

    static func make(remoteID: Int, createdAt: Date) -> SystemSetting {
        let question = SystemSetting()
        question.remoteID = remoteID
        question.createdAt = createdAt
        return question
    }

    func setData(_ data: SystemSettingIntermediary, objectStore: ObjectStore) throws {
        sortOrder = data.sortOrder
        type = data.type
        component = data.component
        format = data.format
        key = data.key
        displayName = data.displayName
        settingDescription = data.settingDescription
        pageIDs = data.pageIDs
        isDefault = data.isDefault
        _value?.delete()
        _value = SettingValueObject(value: data.value)
    }
}
