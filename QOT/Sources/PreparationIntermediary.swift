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
    let calendarEventRemoteID: Int
    let contentID: Int
    
    init(json: JSON) throws {
        self.name = try json.serializeString(at: .name)
        self.subtitle = try json.serializeString(at: .subtitle)
        self.calendarEventRemoteID = try json.getItemValue(at: .eventId)
        self.contentID = try json.getItemValue(at: .contentId)
    }
}
