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
}
