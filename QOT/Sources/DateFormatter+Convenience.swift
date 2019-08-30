//
//  DateFormatter+Convenience.swift
//  QOT
//
//  Created by Sam Wyndham on 19.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

// Creating date formatters are expensive so using a private global variable
private let iso8601DateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale.posix
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    return formatter
}()

private let userDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MMM.yyyy"
    return formatter
}()

private let isoDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    return formatter
}()

private let memberSinceDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMMM yyy"
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    return formatter
}()

private let whatsHotBucketFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d. MMM"
    formatter.timeZone = TimeZone.current
    return formatter
}()

private let dailyPrepDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.timeZone = TimeZone.current
    return formatter
}()

private let myPrepsFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d-MM-hh-mm"
    formatter.timeZone = TimeZone.current
    return formatter
}()

private let mySolvesFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MM yyyy"
    formatter.timeZone = TimeZone.current
    return formatter
}()

private let whatsHotFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd. MMM" // 18. JUL    ..:: "dd. LLLL" 18. JULY ..::
    formatter.timeZone = TimeZone.current
    return formatter
}()

private let coachMessageFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yy - hh:mm"
    formatter.timeZone = TimeZone.current
    return formatter
}()

private let tbvTrackerFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM.yy" // 05.19
    formatter.timeZone = TimeZone.current
    return formatter
}()

private let displayTimeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale.current
    formatter.timeZone = TimeZone.current
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter
}()

private let shortDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale.current
    formatter.timeZone = TimeZone.current
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()

private let mediumDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale.current
    formatter.timeZone = TimeZone.current
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

extension DateFormatter {
    // FIXME: MUST MUST MUST be unit tested.

    static var iso8601: DateFormatter {
        return iso8601DateFormatter
    }

    static var messageDate: DateFormatter {
        return coachMessageFormatter
    }

    static var solveDate: DateFormatter {
        return mySolvesFormatter
    }

    static var memberSince: DateFormatter {
        return memberSinceDateFormatter
    }

    static var displayTime: DateFormatter {
        return displayTimeFormatter
    }

    static var settingsUser: DateFormatter {
        return userDateFormatter
    }

    static var myPrepsTime: DateFormatter {
         return myPrepsFormatter
    }

    static var shortDate: DateFormatter {
        return shortDateFormatter
    }

    static var mediumDate: DateFormatter {
        return mediumDateFormatter
    }

    static var dialyPrep: DateFormatter {
        return dailyPrepDateFormatter
    }

    static var isoDate: DateFormatter {
        return isoDateFormatter
    }

    static var whatsHot: DateFormatter {
        return whatsHotFormatter
    }

    static var tbvTracker: DateFormatter {
        return tbvTrackerFormatter
    }

    static var whatsHotBucket: DateFormatter {
        return whatsHotBucketFormatter
    }
}

extension Locale {
    static var posix: Locale {
        return Locale(identifier: "en_US_POSIX")
    }
}
