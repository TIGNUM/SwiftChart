//
//  GuideItemNotificationIntermediary.swift
//  QOT
//
//  Created by karmic on 11.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct GuideItemNotificationIntermediary: DownSyncIntermediary {

    let title: String?
    let body: String
    let type: String
    let displayType: String
    let greeting: String
    let link: String
    let sound: String
    let priority: Int
    let issueDate: Date
    let displayTime: GuideTimeIntermediary?
    let reminderTime: GuideTimeIntermediary?

    init(json: JSON) throws {
        title = try json.getItemValue(at: .title, alongPath: .nullBecomesNil)
        body = try json.getItemValue(at: .body, fallback: "")
        type = try json.getItemValue(at: .type, fallback: "")
        displayType = try json.getItemValue(at: .displayType, fallback: "")
        greeting = try json.getItemValue(at: .greeting, fallback: "")
        link = try json.getItemValue(at: .link, fallback: "")
        sound = try json.getItemValue(at: .sound, fallback: "")
        priority = try json.getItemValue(at: .priority, fallback: 0)
        issueDate = try json.getDate(at: .issueDate)
        displayTime = try json.getItemValue(at: .displayTime, alongPath: .nullBecomesNil)
        reminderTime = try json.getItemValue(at: .reminderTime, alongPath: .nullBecomesNil)
    }
}
