//
//  ContentReadIntermediary.swift
//  QOT
//
//  Created by Sam Wyndham on 02/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct ContentReadIntermediary {

    let contentCollectionID: Int
    let viewedAt: Date
}

extension ContentReadIntermediary: DownSyncIntermediary {

    init(json: JSON) throws {
        self.contentCollectionID = try json.getItemValue(at: .contentId)
        self.viewedAt = try json.getDate(at: .lastVisitedDate)
    }
}
