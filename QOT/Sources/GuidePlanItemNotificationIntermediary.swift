//
//  GuidePlanItemNotificationIntermediary.swift
//  QOT
//
//  Created by karmic on 11.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct GuidePlanItemNotificationIntermediary: DownSyncIntermediary {

    var planItemID: Int
    var title: String
    var body: String
    var type: String
    var greeting: String
    var link: String
    var priority: Int
    var issueDate: Date
    var reminderTime: Date

    init(json: JSON) throws {
        planItemID = try json.getItemValue(at: .planItemID, fallback: 0)
        title = try json.getItemValue(at: .title, fallback: "")
        body = try json.getItemValue(at: .body, fallback: "")
        type = try json.getItemValue(at: .type, fallback: "")
        greeting = try json.getItemValue(at: .greeting, fallback: "")
        link = try json.getItemValue(at: .link, fallback: "")
        priority = try json.getItemValue(at: .priority, fallback: 0)
        issueDate = try json.getDate(at: .issueDate)
        reminderTime = try json.getDate(at: .reminderTime)
    }
}
