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
    let typeDisplayString: String
    let greeting: String?
    let link: String
    let priority: Int
    let issueDate: Date
    let displayTime: Date

    init(json: JSON) throws {
        title = try json.getItemValue(at: .title, alongPath: .nullBecomesNil)
        body = try json.getItemValue(at: .body, fallback: "")
        type = try json.getItemValue(at: .type, fallback: "")
        typeDisplayString = try json.getItemValue(at: .typeDisplayString, fallback: "")
        greeting = try json.getItemValue(at: .greeting, alongPath: .nullBecomesNil)
        link = try json.getItemValue(at: .link, fallback: "")
        priority = try json.getItemValue(at: .priority, fallback: 0)
        issueDate = try json.getDate(at: .issueDate)
        displayTime = try json.getDate(at: .displayTime)
    }
}
