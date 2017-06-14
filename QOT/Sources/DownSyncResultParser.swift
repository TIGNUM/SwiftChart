//
//  DownSyncChangeParser.swift
//  QOT
//
//  Created by Sam Wyndham on 18.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct DownSyncResult<T>: JSONDecodable where T: JSONDecodable {
    let items: [DownSyncChange<T>]
    let page: Int
    let pageSize: Int
    let maxResults: Int
    let maxPages: Int
    let nextSyncToken: String

    init(json: JSON) throws {
        self.items = try json.getArray(at: JsonKey.resultList.value).map { (json) -> DownSyncChange<T> in
            let syncStatus: SyncStatus = try json.getItemValue(at: .syncStatus)
            let remoteID: Int = try json.getItemValue(at: .id)
            switch syncStatus {
            case .created, .updated:
                let createdAt = try json.getDate(at: .createdAt)
                let modifiedAt = try json.getDate(at: .modifiedAt, alongPath: .NullBecomesNil) ?? createdAt
                let data: T = try T(json: json)

                return .createdOrUpdated(remoteID: remoteID, createdAt: createdAt, modifiedAt: modifiedAt, data: data)
            case .deleted:
                return .deleted(remoteID: remoteID)
            }
        }
        self.page = try json.getItemValue(at: .page)
        self.pageSize = try json.getItemValue(at: .pageSize)
        self.maxResults = try json.getItemValue(at: .maxResults)
        self.maxPages = try json.getItemValue(at: .maxPages)
        self.nextSyncToken = try json.getItemValue(at: .nextSyncToken)
    }
}

struct DownSyncResultParser<T: JSONDecodable> {

    static func parse(_ data: Data) throws -> DownSyncResult<T> {
        let json = try JSON(data: data)
        return try DownSyncResult<T>(json: json)
    }
}

private enum SyncStatus: Int, JSONDecodable {
    case created = 0
    case updated = 1
    case deleted = 2

    init(json: JSON) throws {
        switch json {
        case .int(let int):
            if let status = SyncStatus(rawValue: int) {
                self = status
            } else {
                throw JSON.Error.valueNotConvertible(value: json, to: SyncStatus.self)
            }
        default:
            throw JSON.Error.valueNotConvertible(value: json, to: SyncStatus.self)
        }
    }
}
