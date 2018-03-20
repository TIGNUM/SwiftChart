//
//  NotificationID.swift
//  QOT
//
//  Created by Sam Wyndham on 15/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

struct NotificationID {

    let string: String
}

extension NotificationID {

    private enum Prefix: String {
        case dailyPrep = "daily-prep"
    }

    static func dailyPrep(date: ISODate) -> NotificationID {
        return NotificationID(prefix: .dailyPrep, content: date.string)
    }

    var dailyPrepContent: ISODate? {
        return componants.flatMap { ISODate(string: $0.content) }
    }

    private init(prefix: Prefix, content: String) {
        self.init(string: "\(prefix.rawValue)#\(content)")
    }

    private var componants: (prefix: Prefix, content: String)? {
        let componants = string.components(separatedBy: "#")
        guard componants.count == 2, let prefix = Prefix(rawValue: componants[0]) else { return nil }

        return (prefix, componants[1])
    }
}
