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
}

extension ISODate {

    init?(string: String) {
        let componants = string.components(separatedBy: "-").compactMap { Int($0) }
        guard componants.count == 3 else { return nil }
        self.init(year: componants[0], month: componants[1], day: componants[2])
    }
}
