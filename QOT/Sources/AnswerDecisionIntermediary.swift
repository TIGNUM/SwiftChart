//
//  AnswerDecisionIntermediary.swift
//  QOT
//
//  Created by Sam Wyndham on 07.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct AnswerDecisionIntermediary: JSONDecodable {

    let id: Int
    let questionGroupID: Int
    let targetID: Int?
    let targetType: String?
    let targetGroupID: Int?

    init(json: JSON) throws {
        id = try json.getItemValue(at: .id)
        questionGroupID = try json.getItemValue(at: .questionGroupId)
        targetID = try json.getItemValue(at: .targetTypeId)
        targetType = try json.getItemValue(at: .targetType)
        targetGroupID = try json.getItemValue(at: .targetGroupId)
    }
}
