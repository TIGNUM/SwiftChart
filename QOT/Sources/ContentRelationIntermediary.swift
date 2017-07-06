//
//  ContentRelationIntermediary.swift
//  QOT
//
//  Created by Sam Wyndham on 04.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct ContentRelationIntermediary: JSONDecodable {

    let type: String
    let weight: Int
    let contentID: Int

    init(json: JSON) throws {
        type = try json.getItemValue(at: .contentRelationType)
        weight = try json.getItemValue(at: .weight)
        contentID = try json.getItemValue(at: .contentId)
    }
}
