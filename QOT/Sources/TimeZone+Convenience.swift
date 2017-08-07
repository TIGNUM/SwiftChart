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
        let locale = Locale(identifier: "en_US_POSIX")
        return TimeZone.current.localizedName(for: .shortStandard, locale: locale)!
    }
}
