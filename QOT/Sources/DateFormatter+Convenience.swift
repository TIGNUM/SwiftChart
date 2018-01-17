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
    formatter.dateFormat = "yyyy-MM-dd"
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

    static var displayTime: DateFormatter {
        return displayTimeFormatter
    }

    static var settingsUser: DateFormatter {
        return userDateFormatter
    }

    static var shortDate: DateFormatter {
        return shortDateFormatter
    }

    static var mediumDate: DateFormatter {
        return mediumDateFormatter
    }

    static var utcYearMonthDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.posix
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
}

extension Locale {

    static var posix: Locale {
        return Locale(identifier: "en_US_POSIX")
    }
}
