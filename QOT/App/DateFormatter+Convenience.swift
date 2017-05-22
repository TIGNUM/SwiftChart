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
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    return formatter
}()

extension DateFormatter {
    // FIXME: MUST MUST MUST be unit tested.
    static var iso8601: DateFormatter {
        return iso8601DateFormatter
    }
}
