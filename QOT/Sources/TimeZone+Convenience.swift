//
//  TimeZone+Convenience.swift
//  QOT
//
//  Created by Sam Wyndham on 07.08.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

extension TimeZone {

    static var utc: TimeZone {
        return TimeZone(identifier: "UTC")!
    }

    static var currentName: String {
        return TimeZone.current.localizedName(for: .shortStandard, locale: Locale.posix)!
    }

    static var hoursFromGMT: String {
        let hoursAndMinutes = TimeZone.secondsToHoursMinutes(seconds: TimeZone.current.secondsFromGMT())
        switch hoursAndMinutes {
        case (let hours, let minutes) where hours > 0 && minutes == 0: return String(format: "GMT+%d", hours)
        case (let hours, let minutes) where hours < 0 && minutes == 0: return String(format: "GMT%d", hours)
        case (let hours, let minutes) where hours > 0 && minutes != 0: return String(format: "GMT+%d:%d", hours, minutes)
        case (let hours, let minutes) where hours < 0 && minutes != 0: return String(format: "GMT%d:%d", hours, minutes)
        default: return "GMT+0"
        }
    }

    private static func secondsToHoursMinutes(seconds: Int) -> (Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60)
    }
}
