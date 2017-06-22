//
//  Dictionary+Convenience.swift
//  QOT
//
//  Created by Sam Wyndham on 14.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

extension Dictionary {
    func mapKeys<T>(_ transform: (Key) -> T) -> [T: Value] {
        var result: [T: Value] = [:]
        for (key, value) in self {
            result[transform(key)] = value
        }
        return result
    }

    func mapKeyValues<T, U>(_ transform: (Key, Value) -> (T, U)) -> [T: U] {
        var result: [T: U] = [:]
        for (key, value) in self {
            let mapped = transform(key, value)
            result[mapped.0] = mapped.1
        }
        return result
    }
}
