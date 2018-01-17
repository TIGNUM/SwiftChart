//
//  AnswerIntermediary.swift
//  QOT
//
//  Created by Sam Wyndham on 23.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct AnswerIntermediary: JSONDecodable {

    let remoteID: Int
    let sortOrder: Int
    let title: String
    let subtitle: String?
    let decisions: [AnswerDecisionIntermediary]
    let syncStatus: Int // FIXME: Deleted answers are also returned. We need a better way of hanling this.

    init(json: JSON) throws {
        remoteID = try json.getItemValue(at: .id)
        sortOrder = try json.getItemValue(at: .sortOrder, fallback: 0)
        title = try json.getItemValue(at: .answer, fallback: "")
        subtitle = try json.getItemValue(at: .title)
        decisions = try json.getArray(at: .decisions, fallback: [])
        syncStatus = try json.getItemValue(at: .syncStatus, fallback: 0)
    }
}
