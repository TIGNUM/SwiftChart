//
//  QuestionGroupIntermediary.swift
//  QOT
//
//  Created by Sam Wyndham on 07.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct QuestionGroupIntermediary: JSONDecodable {

    let id: Int
    let name: String

    init(json: JSON) throws {
        self.id = try json.getItemValue(at: .id)
        self.name = try json.getItemValue(at: .name, fallback: "")
    }
}
