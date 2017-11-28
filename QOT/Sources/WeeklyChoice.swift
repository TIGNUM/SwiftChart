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
