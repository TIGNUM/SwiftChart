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

    var title: String?
    var body: String
    var type: String
    var greeting: String?
    var link: String
    var priority: Int
    var issueDate: Date

    init(json: JSON) throws {
        title = try json.getItemValue(at: .title, alongPath: .nullBecomesNil)
        body = try json.getItemValue(at: .body, fallback: "")
        type = try json.getItemValue(at: .type, fallback: "")
        greeting = try json.getItemValue(at: .greeting, alongPath: .nullBecomesNil)
        link = try json.getItemValue(at: .link, fallback: "")
        priority = try json.getItemValue(at: .priority, fallback: 0)
        issueDate = Date()//try json.getDate(at: .issueDate)
    }
}
