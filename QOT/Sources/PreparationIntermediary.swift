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

    let contentID: Int
    let calendarEventRemoteId: Int
    let title: String
    let subtitle: String
    
    init(json: JSON) throws {
        self.contentID = try json.getItemValue(at: .contentId)
        self.calendarEventRemoteId = try json.getItemValue(at: .eventId)
        self.title = try json.serializeString(at: .title)
        self.subtitle = try json.serializeString(at: .subtitle)
    }
}
