//
//  StatisticsPeriod.swift
//  QOT
//
//  Created by karmic on 11.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class StatisticsPeriod: Object {

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

    @objc dynamic var startDate = Date()

    @objc dynamic var endDate = Date()

    @objc dynamic var _status = ""

    convenience init(_ data: StatisticsPeriodIntermediary) {
        self.init()

        self.startDate = data.startDate
        self.endDate = data.endDate
        self._status = data.status
    }

    convenience init(start: Date, end: Date, status: StatisticsPeriod.Status) {
        self.init()

        self.startDate = start
        self.endDate = end
        self._status = status.rawValue
    }

    func delete() {
        if let realm = realm {
            realm.delete(self)
        }
    }
}

extension StatisticsPeriod {

    var range: Range<Date> {
        return startDate ..< endDate
    }

    var status: Status {
        return Status(rawValue: _status) ?? .normal
    }

    var minutes: Int {
        return Int(endDate.timeIntervalSince(startDate).toInt / 60)
    }

    var startMinute: Int {
        return startDate.minutesSinceMidnight
    }

    var endMinute: Int {
        return endDate.minutesSinceMidnight
    }
}
