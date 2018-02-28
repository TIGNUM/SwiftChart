//
//  UserAnswerIntermediary.swift
//  QOT
//
//  Created by Sam Wyndham on 23/02/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct UserAnswerIntermediary: DownSyncIntermediary {

    let questionID: Int
    let questionGroupID: Int
    let answerID: Int
    let userAnswer: String
    let notificationID: Int?

    init(json: JSON) throws {
        questionID = try json.getItemValue(at: .questionId)
        questionGroupID = try json.getItemValue(at: .questionGroupId)
        answerID = try json.getItemValue(at: .answerId)
        userAnswer = try json.getItemValue(at: .userAnswer, fallback: "")
        notificationID = try json.getItemValue(at: .notificationId, alongPath: .nullBecomesNil)
    }
}
