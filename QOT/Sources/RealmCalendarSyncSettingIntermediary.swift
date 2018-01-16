//
//  RealmCalendarSyncSettingIntermediary.swift
//  QOT
//
//  Created by Sam Wyndham on 16/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct RealmCalendarSyncSettingIntermediary: DownSyncIntermediary {

    let calendarIdentifier: String
    let title: String
    let syncEnabled: Bool

    init(json: JSON) throws {
        self.calendarIdentifier = try json.getItemValue(at: .calendarId, fallback: "")
        self.title = try json.getItemValue(at: .title, fallback: "")
        self.syncEnabled = try json.getItemValue(at: .syncEnabled)
    }
}
