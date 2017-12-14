//
//  GuideItemIntermediary.swift
//  QOT
//
//  Created by karmic on 14.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct GuideItemIntermediary: DownSyncIntermediary {

    let planItemID: Int
    let title: String?
    let body: String
    let type: String
    let typeDisplayString: String
    let greeting: String?
    let link: String
    let priority: Int
    let block: Int
    let completedAt: Date?
    let feedback: String?
    let dailyPrepResults: [Int]

    init(json: JSON) throws {
        planItemID = try json.getItemValue(at: .planItemID)
        title = try json.getItemValue(at: .title, alongPath: .nullBecomesNil)
        body = try json.getItemValue(at: .body, fallback: "")
        type = try json.getItemValue(at: .type, fallback: "")
        typeDisplayString = try json.getItemValue(at: .typeDisplayString, fallback: "")
        greeting = try json.getItemValue(at: .greeting, alongPath: .nullBecomesNil)
        link = try json.getItemValue(at: .link, fallback: "")
        priority = try json.getItemValue(at: .priority, fallback: 0)
        block = try json.getItemValue(at: .block, fallback: 0)
        completedAt = try json.getDate(at: .completedAt, alongPath: .nullBecomesNil)
        feedback = try json.getItemValue(at: .feedback, alongPath: .nullBecomesNil)
        dailyPrepResults = try json.getArray(at: .dailyPrepResults, fallback: [])
    }
}
