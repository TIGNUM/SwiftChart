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

    dynamic var endDate = Date()

    convenience init(_ data: MyStatisticsPeriodIntermediary) {
        self.init()

        self.startDate = data.startDate
        self.endDate = data.endDate
    }
}

extension MyStatisticsPeriod {

    var range: Range<Date> {
        return startDate..<endDate
    }
}
