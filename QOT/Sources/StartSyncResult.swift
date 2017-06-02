//
//  StartSyncTokenParser.swift
//  QOT
//
//  Created by Sam Wyndham on 30.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct StartSyncResult {
    let syncToken: String
    let syncDate: Int64

    init(json: JSON) throws {
        self.syncToken = try json.getItemValue(at: .nextSyncToken)
        self.syncDate = try json.getInt64(at: .syncTime)
    }

    static func parse(_ data: Data) throws -> StartSyncResult {
        let json = try JSON(data: data)
        return try StartSyncResult(json: json)
    }
}
