//
//  UserAnswerFeedback.swift
//  QOT
//
//  Created by karmic on 21.09.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct UserAnswerFeedback {

    let title: String?
    let body: String?

    init(json: JSON) throws {
        title = try json.getItemValue(at: .title)
        body = try json.getItemValue(at: .body)
    }

    static func parse(_ data: Data) throws -> UserAnswerFeedback {
        return try UserAnswerFeedback(json: try JSON(data: data))
    }
}
