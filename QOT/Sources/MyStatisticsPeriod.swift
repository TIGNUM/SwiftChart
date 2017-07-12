//
//  MyStatisticsPeriod.swift
//  QOT
//
//  Created by karmic on 11.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class MyStatisticsPeriod: Object {

    dynamic var startDate = Date()

    dynamic var enbdDate = Date()

    convenience init(_ data: MyStatisticsPeriodIntermediary) {
        self.init()

        self.startDate = data.startDate
        self.enbdDate = data.endDate
    }
}
