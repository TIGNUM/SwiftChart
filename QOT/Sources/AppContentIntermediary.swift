//
//  AppContentIntermediary.swift
//  QOT
//
//  Created by karmic on 01.10.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct AppContentIntermediary {
    let key: String
    let description: String
    let contentItemId: Int
}

extension AppContentIntermediary: DownSyncIntermediary {

    init(json: JSON) throws {
        self.key = try json.getItemValue(at: .key, fallback: "")
        self.description = try json.getItemValue(at: .description, fallback: "")
        self.contentItemId = try json.getItemValue(at: .contentItemId, fallback: 0)
    }
}
