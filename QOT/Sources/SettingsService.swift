//
//  SettingsService.swift
//  QOT
//
//  Created by Sam Wyndham on 07.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class SettingsService {

    // MARK: - Properties

    private let realm: Realm

    // MARK: - Init

    init(realm: Realm) {
        self.realm = realm
    }
}

// MARK: - Public

extension SettingsService {

    var guideDays: Int? {
        return integer(key: "system.notification.guidedays")
    }

    var daysToExpire: Int? {
        guard let stringValue = string(key: "system.qot.subscription.daysToExpire") else { return nil }
        return Int(stringValue)
    }

    var releaseManagerMinimalVersion: String? {
        return string(key: "system.qot.release-manager-minimal-version")
    }

    func notificationSettings() -> AnyRealmCollection<SystemSetting> {
        let predicate = NSPredicate(format: "key BEGINSWITH[c] %@", "system.notification.")

        return AnyRealmCollection(realm.objects(SystemSetting.self).filter(predicate))
    }

    func settingValue(key: String) -> SettingValue? {
        if let systemSetting = systemSetting(key: key) {
            return userSetting(systemSetting: systemSetting)?.value ?? systemSetting.value
        }
        return nil
    }

    func integer(key: String) -> Int? {
        guard let value = settingValue(key: key) else { return nil }

        switch value {
        case .int(let int, _, _):
            return int
        default:
            return nil
        }
    }

    func string(key: String) -> String? {
        // Backend is changing now the SystemSetting Data Scheme... Need to be handled more later...
        if  let systemSet = systemSetting(key: key), userSetting(systemSetting: systemSet)?.value == nil {
                return systemSet.textValue.isEmpty ? nil : systemSet.textValue
        }

        if let value = settingValue(key: key) {
            switch value {
            case .text(let text):
                return text
            default:
                return nil
            }
        }
        return nil
    }

    func allowAdminSettings() -> Bool {
        if let systemSetting = systemSetting(key: "system.developmentmode") {
            let seetingValue = userSetting(systemSetting: systemSetting)?.value ?? systemSetting.value
            switch seetingValue {
            case .bool(let value): return value
            default: return false
            }
        }

        return false
    }

    func setSettingValue(_ value: SettingValue, key: String) throws {
        if let systemSetting = systemSetting(key: key) {
            try realm.write {
                if let userSetting = userSetting(systemSetting: systemSetting) {
                    userSetting.value = value
                } else {
                    let newSetting = UserSetting(with: value)
                    newSetting.remoteID.value = systemSetting.remoteID.value
                    realm.add(newSetting)
                }
            }
        } else {
            log("Unable to set value: \(value). No system setting with key: \(key)", level: .error)
        }
    }
}

// MARK: - Private

private extension SettingsService {

    func userSetting(systemSetting: SystemSetting) -> UserSetting? {
        return realm.syncableObject(ofType: UserSetting.self, remoteID: systemSetting.forcedRemoteID)
    }

    func systemSetting(key: String) -> SystemSetting? {
        return realm.objects(SystemSetting.self).filter(.key(key)).first
    }
}
