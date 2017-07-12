//
//  UserSettingIntermediary.swift
//  QOT
//
//  Created by Sam Wyndham on 11.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct UserSettingIntermediary: DownSyncIntermediary {

    static var remoteIDKey: JsonKey {
        return .settingId
    }

    var format: String
    var value: SettingValue

    init(json: JSON) throws {
        let format: SettingFormat = try json.getItemValue(at: .format)
        self.format = format.rawValue
        self.value = try SettingValue(json: json, format: format)
    }
}
