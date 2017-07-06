//
//  JSON+Convenience.swift
//  QOT
//
//  Created by Sam Wyndham on 29.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

extension JSON {

    func getItemValue<T: JSONDecodable>(at jsonKey: JsonKey) throws -> T {
        return try decode(at: jsonKey.value, type: T.self)
    }

    func getItemValue<T: JSONDecodable>(at jsonKey: JsonKey) throws -> T? {
        return try decode(at: jsonKey.value, alongPath: [.MissingKeyBecomesNil, .NullBecomesNil])
    }

    func getItemValue<T: JSONDecodable>(at jsonKey: JsonKey, alongPath options: SubscriptingOptions) throws -> T? {
        return try decode(at: jsonKey.value, alongPath: options)
    }

    func getArray<T: JSONDecodable>(at jsonKey: JsonKey) throws -> [T] {
        let jsons = try getArray(at: jsonKey.value, alongPath: [.MissingKeyBecomesNil, .NullBecomesNil]) ?? []
        return try jsons.map { try T(json: $0) }
    }

    func getInt64(at jsonKey: JsonKey) throws -> Int64 {
        do {
            let int = try getInt(at: jsonKey.value)
            return Int64(int)
        } catch {
            let string = try getString(at: jsonKey.value)
            guard let int64 = Int64(string) else {
                throw JSON.Error.valueNotConvertible(value: self, to: Int64.self)
            }
            return int64
        }
    }

    func serializeString(at jsonKey: JsonKey) throws -> String? {
        guard let json = self[jsonKey.value], json != .null else {
            return nil
        }
        return try json.serializeString()
    }

    func serializeString(at jsonKey: JsonKey) throws -> String {
        guard let json = self[jsonKey.value], json != .null else {
            throw JSON.Error.keyNotFound(key: jsonKey.value)
        }
        return try json.serializeString()
    }

    func json(at key: JsonKey) throws -> JSON {
        guard let json = self[key.value], json != .null else {
            throw JSON.Error.keyNotFound(key: key.value)
        }
        return json
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

    func getDate(at jsonKey: JsonKey) throws -> Date {
        let formatter = DateFormatter.iso8601
        let dateString: String = try getItemValue(at: jsonKey)

        guard let date = formatter.date(from: dateString) else {
            throw JSON.Error.valueNotConvertible(value: self, to: Date.self)
        }
        return date
    }

    func getDate(at jsonKey: JsonKey, alongPath options: SubscriptingOptions) throws -> Date? {
        let formatter = DateFormatter.iso8601
        guard let dateString: String = try getItemValue(at: jsonKey, alongPath: options) else {
            return nil
        }

        guard let date = formatter.date(from: dateString) else {
            throw JSON.Error.valueNotConvertible(value: self, to: Date.self)
        }
        return date
    }
}
