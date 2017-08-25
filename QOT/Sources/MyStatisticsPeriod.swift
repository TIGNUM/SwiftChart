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

    enum Status: String {
        case low = "LOW"
        case normal = "NORMAL"
        case critical = "CRITICAL"
    }

    dynamic var startDate = Date()

    dynamic var endDate = Date()

    dynamic var _status = ""

    convenience init(_ data: MyStatisticsPeriodIntermediary) {
        self.init()

        self.startDate = data.startDate
        self.endDate = data.endDate
        self._status = data.status
    }
}

extension MyStatisticsPeriod {

    var range: Range<Date> {
        return startDate..<endDate
    }

    var status: Status {
        return Status(rawValue: _status) ?? .normal
    }
}
