//
//  GuidePlanItemLearnIntermediary.swift
//  QOT
//
//  Created by karmic on 11.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct GuidePlanItemLearnIntermediary {

    var planItemID: Int
    var title: String
    var body: String
    var type: String
    var greeting: String
    var link: String
    var priority: Int
    var day: Int
    var reminderTime: Date

    init(json: JSON) throws {
        planItemID = try json.getItemValue(at: .planItemID)
        title = try json.getItemValue(at: .title)
        body = try json.getItemValue(at: .body)
        type = try json.getItemValue(at: .type)
        greeting = try json.getItemValue(at: .greeting)
        link = try json.getItemValue(at: .link)
        priority = try json.getItemValue(at: .priority)
        day = try json.getItemValue(at: .day)
        reminderTime = try json.getDate(at: .reminderTime)
    }
}
