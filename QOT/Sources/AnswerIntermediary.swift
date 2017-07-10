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

    let sortOrder: Int
    let title: String
    let subtitle: String?
    let decisions: [AnswerDecisionIntermediary]

    init(json: JSON) throws {
        sortOrder = try json.getItemValue(at: .sortOrder, fallback: 0)
        title = try json.getItemValue(at: .answer, fallback: "")
        subtitle = try json.getItemValue(at: .title)
        decisions = try json.getArray(at: .decisions, fallback: [])
    }
}
