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

    private let realm: Realm

    init(realm: Realm) {
        self.realm = realm
    }

    func settingValue(key: String) -> SettingValue? {
        if let systemSetting = systemSetting(key: key) {
            return userSetting(systemSetting: systemSetting)?.value ?? systemSetting.value
        }
        return nil
    }

    func setSettingValue(_ value: SettingValue, key: String) {
        // FIXME: Implement
    }

    private func userSetting(systemSetting: SystemSetting) -> UserSetting? {
        return realm.object(ofType: UserSetting.self, forPrimaryKey: systemSetting.remoteID)
    }

    private func systemSetting(key: String) -> SystemSetting? {
        return realm.objects(SystemSetting.self).filter(.key(key)).first
    }
}
