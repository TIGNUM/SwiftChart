//
//  PreparationIntermediary.swift
//  QOT
//
//  Created by Sam Wyndham on 26.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct PreparationIntermediary: DownSyncIntermediary {

    let name: String
    let subtitle: String
    let calendarEventRemoteID: Int?

    init(json: JSON) throws {
        self.name = try json.getItemValue(at: .name, fallback: "")
        self.subtitle = try json.getItemValue(at: .subtitle, fallback: "")
        self.calendarEventRemoteID = try json.getItemValue(at: .eventId)
    }
}
