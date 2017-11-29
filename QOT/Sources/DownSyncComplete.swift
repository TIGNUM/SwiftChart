//
//  DownSyncComplete.swift
//  QOT
//
//  Created by Moucheg Mouradian on 07/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct DownSyncComplete {
    let syncToken: String
    let syncTokenHeaderKey: String

    init(json: JSON) throws {
        self.syncToken = try json.getItemValue(at: .nextSyncToken)
        self.syncTokenHeaderKey = try json.getItemValue(at: .syncTokenHeaderKey)
    }

    static func parse(_ data: Data) throws -> DownSyncComplete {
        let json = try JSON(data: data)
        return try DownSyncComplete(json: json)
    }
}
