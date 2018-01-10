//
//  QuestionIntermediary.swift
//  QOT
//
//  Created by Sam Wyndham on 23.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct QuestionIntermediary: DownSyncIntermediary {

    let sortOrder: Int
    let title: String
    let dailyPrepTitle: String?
    let answersDescription: String?
    let answers: [AnswerIntermediary]
    let groups: [QuestionGroupIntermediary]

    init(json: JSON) throws {
        sortOrder = try json.getItemValue(at: .sortOrder, fallback: 0)
        title = try json.getItemValue(at: .question, fallback: "")
        dailyPrepTitle = try json.getItemValue(at: .title, alongPath: .nullBecomesNil)
        answersDescription = try json.getItemValue(at: .questionDescription)
        answers = try json.getArray(at: .answers, fallback: [])
        groups = try json.getArray(at: .questionGroups, fallback: [])
    }
}
