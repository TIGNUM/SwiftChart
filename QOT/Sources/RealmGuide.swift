//
//  Guide.swift
//  QOT
//
//  Created by karmic on 11.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy

final class RealmGuide: Object {

    /// A string representing the UTC date in format `yyyyMMdd`
    @objc dynamic var date: String = ""

    var items = List<RealmGuideItem>()

    override class func primaryKey() -> String? {
        return "date"
    }

    convenience init(items: List<RealmGuideItem>, date: Date) {
        self.init()
        self.items = items
        self.date = RealmGuide.dateString(date: date)
    }

    static func dateString(date: Date) -> String {
        return DateFormatter.utcYearMonthDay.string(from: date)
    }

    var createdAt: Date {
        guard let createdAt = DateFormatter.utcYearMonthDay.date(from: date) else {
            assertionFailure("RealmGuide date string (\(date) cannot be converted to Date type")
            return Date.distantPast
        }
        return createdAt
    }
}
