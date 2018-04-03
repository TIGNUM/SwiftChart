//
//  PreparationIntermediary.swift
//  QOT
//
//  Created by Sam Wyndham on 26.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct PreparationIntermediary: DownSyncIntermediary {

    let name: String
    let subtitle: String
    let notes: String
    let calendarEventRemoteID: Int?
    let answers: [PreparationAnswerIntermediary]

    init(json: JSON) throws {
        self.name = try json.getItemValue(at: .name, fallback: "")
        self.subtitle = try json.getItemValue(at: .subtitle, fallback: "")
        self.notes = try json.getItemValue(at: .note, fallback: "")
        self.calendarEventRemoteID = try json.getItemValue(at: .eventId)
        self.answers = try json.getArray(at: .prepareAnswers, fallback: [])
    }
}

struct PreparationAnswerIntermediary: JSONDecodable {
    let contentItemID: Int
    let answer: String

    init(json: JSON) throws {
        self.contentItemID = try json.getItemValue(at: .contentItemId)
        self.answer =  try json.getItemValue(at: .answer)
    }
}
