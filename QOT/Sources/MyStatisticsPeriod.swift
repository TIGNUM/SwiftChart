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

        var color: UIColor {
            switch self {
            case .critical: return .cherryRed
            case .low: return .gray
            case .normal: return .white90
            }
        }
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

    convenience init(start: Date, end: Date, status: MyStatisticsPeriod.Status) {
        self.init()

        self.startDate = start
        self.endDate = end
        self._status = status.rawValue
    }
}

extension MyStatisticsPeriod {

    var range: Range<Date> {
        return startDate ..< endDate
    }

    var status: Status {
        return Status(rawValue: _status) ?? .normal
    }
}
