//
//  WeeklyChoice.swift
//  QOT
//
//  Created by Lee Arromba on 12/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

struct WeeklyChoice {
    let localID: String
    var contentCollectionID: Int
    var categoryID: Int
    var title: String?
    var startDate: Date
    var endDate: Date
    var selected: Bool
}
