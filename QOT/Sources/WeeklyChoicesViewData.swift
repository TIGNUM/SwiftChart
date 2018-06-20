//
//  WeeklyChoicesViewData.swift
//  QOT
//
//  Created by Lee Arromba on 23/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

struct WeeklyChoicesViewData {

    struct Item {
        let title: String?
        var subtitle: String?
        let categoryName: String?
        let contentCollectionID: Int?
        let categoryID: Int?
    }

    let items: [Item]

    init(items: [Item]) {
        self.items = items
    }
}
