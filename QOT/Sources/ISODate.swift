//
//  ISODate.swift
//  QOT
//
//  Created by Sam Wyndham on 15/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

struct ISODate {

    var year: Int
    var month: Int
    var day: Int

    var string: String {
        return String(format: "%04d-%02d-%02d", year, month, day)
    }

    var date: Date? {
        return DateFormatter.isoDate.date(from: self.string)
    }

    var isToday: Bool {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        return dateComponents.year == year && dateComponents.month == month && dateComponents.day == day
    }
}

extension ISODate {

    init?(string: String) {
        let components = string.components(separatedBy: "-").compactMap { Int($0) }
        guard components.count == 3 else { return nil }
        self.init(year: components[0], month: components[1], day: components[2])
    }
}
