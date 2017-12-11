//
//  WeeklyChoice.swift
//  QOT
//
//  Created by Lee Arromba on 23/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

struct WeeklyChoice {
    let localID: String
    let contentCollectionID: Int
    let categoryID: Int
    let categoryName: String?
    let title: String?
    let startDate: Date
    let endDate: Date
    var selected: Bool
}

// MARK: - Equatable

extension WeeklyChoice: Equatable {
    static func == (lhs: WeeklyChoice, rhs: WeeklyChoice) -> Bool {
        return lhs.localID == rhs.localID
            && lhs.contentCollectionID == rhs.contentCollectionID
            && lhs.categoryID == rhs.categoryID
            && lhs.categoryName == rhs.categoryName
            && lhs.title == rhs.title
            && lhs.startDate == rhs.startDate
            && lhs.endDate == rhs.endDate
            && lhs.selected == rhs.selected
    }
}

func == (lhs: [WeeklyChoice], rhs: [WeeklyChoice]) -> Bool {
    guard lhs.count == rhs.count else { return false }
    var i1 = lhs.makeIterator()
    var i2 = rhs.makeIterator()
    var isEqual = true
    while let e1 = i1.next(), let e2 = i2.next(), isEqual {
        isEqual = e1 == e2
    }
    return isEqual
}
