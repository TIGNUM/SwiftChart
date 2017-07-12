//
//  UserChoiceIntermediary.swift
//  QOT
//
//  Created by Sam Wyndham on 12.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct UserChoiceIntermediary: DownSyncIntermediary {

    let type: String
    let userText: String?
    let startDate: Date
    let endDate: Date
    let contentCategoryID: Int?
    let contentCollectionID: Int?

    init(json: JSON) throws {
        type = try json.getItemValue(at: .type)
        userText = try json.getItemValue(at: .ownText)
        startDate = try json.getDate(at: .startDate)
        endDate = try json.getDate(at: .endDate)
        contentCategoryID = try json.getItemValue(at: .contentCategoryId)
        contentCollectionID = try json.getItemValue(at: .contentId)
    }
}
