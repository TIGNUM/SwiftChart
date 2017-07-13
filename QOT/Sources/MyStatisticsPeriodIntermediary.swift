//
//  MyStatisticsPeriodIntermediary.swift
//  QOT
//
//  Created by karmic on 11.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct MyStatisticsPeriodIntermediary: DownSyncIntermediary {

    let startDate: Date
    let endDate: Date

    init(json: JSON) throws {
        startDate = try json.getDate(at: .start)
        endDate = try json.getDate(at: .end)
    }
}
