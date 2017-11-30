//
//  UpSyncResultParser.swift
//  QOT
//
//  Created by Sam Wyndham on 21.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

typealias LocalIDToRemoteIDMap = [String: Int]

struct UpSyncResult {

    let remoteIDs: LocalIDToRemoteIDMap
    let nextSyncToken: String

    init(json: JSON) throws {
        var remoteIDs: LocalIDToRemoteIDMap = [:]
        let resultList: [JSON] = try json.getArray(at: .resultList, fallback: [])
        for json in resultList {
            if let localID: String = try json.getItemValue(at: .qotId),
                let remoteID: Int = try json.getItemValue(at: .id) {
                remoteIDs[localID] = remoteID
            }
        }
        self.remoteIDs = remoteIDs
        self.nextSyncToken = try json.getItemValue(at: .nextSyncToken)
    }
}

struct UpSyncResultParser {

    static func parse(_ data: Data) throws -> UpSyncResult {
        let json = try JSON(data: data)
        return try UpSyncResult(json: json)
    }
}
