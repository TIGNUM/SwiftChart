//
//  DailyPrepResultIntermediary.swift
//  QOT
//
//  Created by Sam Wyndham on 16/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct DailyPrepResultIntermediary: DownSyncIntermediary {

    struct Answer: JSONDecodable {

        let value: Int
        let colorState: String?
        let title: String

        init(json: JSON) throws {
            value = try json.getItemValue(at: .userAnswer, fallback: 0)
            colorState = try json.getItemValue(at: .colorState)
            title = try json.getItemValue(at: .questionTitle)
        }
    }

    let isoDate: String
    let title: String
    let feedback: String?
    let answers: [Answer]

    init(json: JSON) throws {
        isoDate = try json.getItemValue(at: .yearMonthDay)
        title = try json.getItemValue(at: .title)
        feedback = try json.getItemValue(at: .body)
        answers = try json.getArray(at: .userAnswers)
    }
}
