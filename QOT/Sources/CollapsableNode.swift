//
//  CollapsableNode.swift
//  QOT
//
//  Created by Lee Arromba on 11/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

struct CollapsableNode {
    let title: String?
    var children: [Choice]
    var isOpen: Bool

    var numberOfRows: Int {
        return isOpen == true ? children.count : 0
    }

    func item(forRow row: Int) -> Choice? {
        return children.at(index: row)
    }

    mutating func replace(_ item: Choice, atRow row: Int) {
        children[row] = item
    }
}
