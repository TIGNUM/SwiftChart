//
//  Array+Convenience.swift
//  QOT
//
//  Created by karmic on 26.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {

    /// Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

extension Array where Element : Equatable {

    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            if !uniqueValues.contains(item) {
                uniqueValues += [item]
            }
        }
        return uniqueValues
    }
}
