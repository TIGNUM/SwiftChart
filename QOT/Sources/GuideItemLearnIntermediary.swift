//
//  GuideItemLearnIntermediary.swift
//  QOT
//
//  Created by karmic on 11.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct GuideItemLearnIntermediary: DownSyncIntermediary {

    let title: String
    let body: String
    let type: String
    let displayType: String
    let greeting: String
    let link: String
    let sound: String
    let featureLink: String
    let contentID: Int
    let priority: Int
    let block: Int
    let displayTime: GuideTimeIntermediary?
    let reminderTime: GuideTimeIntermediary?
    let completedAt: Date?

    init(json: JSON) throws {
        title = try json.getItemValue(at: .title, fallback: "")
        body = try json.getItemValue(at: .body, fallback: "")
        type = try json.getItemValue(at: .guideItemType, fallback: "")
        displayType = try json.getItemValue(at: .displayType, fallback: "")
        greeting = try json.getItemValue(at: .greeting, fallback: "")
        link = try json.getItemValue(at: .link, fallback: "")
        sound = try json.getItemValue(at: .sound, fallback: "")
        featureLink = try json.getItemValue(at: .featureLink, fallback: "")
        contentID = try json.getItemValue(at: .contentId, fallback: 0)
        priority = try json.getItemValue(at: .priority, fallback: 0)
        block = try json.getItemValue(at: .block, fallback: 0)
        displayTime = try json.getItemValue(at: .displayTime, alongPath: .nullBecomesNil)
        reminderTime = try json.getItemValue(at: .reminderTime, alongPath: .nullBecomesNil)
        completedAt = try json.getDate(at: .completed, alongPath: .nullBecomesNil)
    }
}
