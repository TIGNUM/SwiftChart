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
    let typeDisplayString: String
    let greeting: String
    let link: String
    let featureLink: String
    let contentID: Int
    let priority: Int
    let block: Int
    let reminderTime: GuideTimeIntermediary
    let displayTime: GuideTimeIntermediary
    let completedAt: Date?

    init(json: JSON) throws {
        title = try json.getItemValue(at: .title, fallback: "")
        body = try json.getItemValue(at: .body, fallback: "")
        type = try json.getItemValue(at: .guideItemType, fallback: "")
//        typeDisplayString = try json.getItemValue(at: .typeDisplayString, fallback: "")
        greeting = try json.getItemValue(at: .greeting, fallback: "")
        link = try json.getItemValue(at: .link, fallback: "")
        featureLink = try json.getItemValue(at: .featureLink, fallback: "")
        contentID = try json.getItemValue(at: .contentId, fallback: 0)
        priority = try json.getItemValue(at: .priority, fallback: 0)
        block = try json.getItemValue(at: .block, fallback: 0)
        reminderTime = try json.getItemValue(at: .reminderTime)
        displayTime = try json.getItemValue(at: .displayTime)
        completedAt = try json.getDate(at: .completed, alongPath: .nullBecomesNil)
        typeDisplayString = type
    }
}
