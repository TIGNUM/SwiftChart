//
//  CollapsableNode.swift
//  QOT
//
//  Created by Lee Arromba on 11/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

struct CollapsableNode {

    let title: String?
    var children: [WeeklyChoice]
    var isOpen: Bool

    var numberOfRows: Int {
        if isOpen == true {
            return children.count
        }
        return 0
    }

    func item(forRow row: Int) -> WeeklyChoice {
        return children[row]
    }

    mutating func replace(_ item: WeeklyChoice, atRow row: Int) {
        children[row] = item
    }
}
