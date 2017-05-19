//
//  DatabaseConstants.swift
//  QOT
//
//  Created by karmic on 12.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

enum Database {

    enum Section: String {
        case learnStrategy = "learn.strategie"
        case prepareCoach = "prepare.coach"
    }
}

enum JsonKey: String {
    case results
    case identifier
    case syncStatus
    case createdAt
    case modifiedAt
    case sortOrder
    case section
    case title
    case subtitle
    case keypathID
    case layoutInfo
    case page
    case pageSize
    case maxResults
    case maxPages
    case timestamp
    case relatedContentIDs
    case categoryIDs
    case categoryID
    case searchTags
    case secondsRequired
    case value
    case format
    case viewed

    var value: String {
        return rawValue
    }
}

extension JSON {

    func getItemValue<T: JSONDecodable>(at jsonKey: JsonKey) throws -> T {
        return try decode(at: jsonKey.value, type: T.self)
    }

    func getItemValue<T: JSONDecodable>(at jsonKey: JsonKey, alongPath options: SubscriptingOptions) throws -> T? {
        return try decode(at: jsonKey.value, alongPath: options)
    }

    func getArray<T: JSONDecodable>(at jsonKey: JsonKey) throws -> [T] {
        return try getArray(at: "").map { try T(json: $0) }
    }

    subscript(key: JsonKey) -> JSON? {
        return self[key.value]
    }

    func makeJSONDictionary(_ jsonDict: [Swift.String: Any]) throws -> JSON {
        return try JSON(jsonDict.lazy.map { (key, value) in
            try (key, self.makeMyJSON(with: value))
        })
    }

    private func makeMyJSON(with object: Any) throws -> JSON {
        switch object {
        case let dict as [Swift.String: Any]: return try makeJSONDictionary(dict)
        default: return .null
        }
    }
}
