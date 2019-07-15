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

extension Array where Element: Equatable {

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

extension Array {
    func at(index: Int) -> Element? {
        if index < 0 || index > count - 1 {
            return nil
        }
        return self[index]
    }

    var randomIndex: Int {
        return Int.random(in: 0..<count)
    }

    func contains<T>(obj: T) -> Bool where T: Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}
