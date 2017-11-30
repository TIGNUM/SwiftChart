//
//  TimeZone+Convenience.swift
//  QOT
//
//  Created by Sam Wyndham on 07.08.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

extension TimeZone {

    static var currentName: String {
        return TimeZone.current.localizedName(for: .shortStandard, locale: Locale.posix)!
    }

    static var hoursFromGMT: String {
        let offsetHours = Float(TimeZone.current.secondsFromGMT()) / 3600
        switch offsetHours {
        case let offset where offset > 0: return String(format: "GMT+%.0f", offsetHours)
        case let offset where offset < 0: return String(format: "GMT%.0f", offsetHours)
        default: return "GMT+0"
        }
    }
}
