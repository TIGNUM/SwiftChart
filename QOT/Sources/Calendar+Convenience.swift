//
//  Calendar+Convenience.swift
//  QOT
//
//  Created by karmic on 09.10.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

extension Calendar {

    static var sharedUTC: Calendar {
        var calendar = Calendar.current
        calendar.locale = Locale.posix

        if let timeZone = TimeZone(abbreviation: "UTC") {
            calendar.timeZone = timeZone
        } else {
            fatalError("Calendar timezone error - abbreviation: UTC")
        }

        return calendar
    }
}
