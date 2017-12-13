//
//  GuidePlanItemLearnIntermediary.swift
//  QOT
//
//  Created by karmic on 11.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct GuidePlanItemLearnIntermediary: DownSyncIntermediary {

    var title: String
    var body: String
    var type: String
    var greeting: String
    var link: String
    var priority: String
    var day: String
    var reminderTime: Date

    init(json: JSON) throws {
        title = try json.getItemValue(at: .title, fallback: "")
        body = try json.getItemValue(at: .body, fallback: "")
        type = try json.getItemValue(at: .type, fallback: "")
        greeting = try json.getItemValue(at: .greeting, fallback: "")
        link = try json.getItemValue(at: .link, fallback: "")
        priority = try json.getItemValue(at: .priority, fallback: "")
        day = try json.getItemValue(at: .day, fallback: "")
        reminderTime = try json.getDate(at: .reminderTime)
    }
}
