//
//  CalendarEventIntermediary.swift
//  QOT
//
//  Created by Sanggeon Park on 24.05.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct CalendarEventIntermediary: DownSyncIntermediary {

    let deleted: Bool
    let ekModifiedAt: Int
    let title: String
    let startDateString: String
    let endDateString: String
    let calendarItemExternalIdentifier: String
    let calendarIdentifier: String

    init(json: JSON) throws {
        deleted = false
        title = try json.getItemValue(at: .title, fallback: "")
        ekModifiedAt = try json.getItemValue(at: .modifiedAt, fallback: 0)
        startDateString = try json.getItemValue(at: .startDate, fallback: "")
        endDateString = try json.getItemValue(at: .endDate, fallback: "")
        calendarItemExternalIdentifier = try json.getItemValue(at: .calendarItemExternalId, fallback: "")
        calendarIdentifier = try json.getItemValue(at: .calendarId, fallback: "")
    }
}
