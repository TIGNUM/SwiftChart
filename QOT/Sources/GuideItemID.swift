//
//  GuideItemID.swift
//  QOT
//
//  Created by Sam Wyndham on 19.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

/**
 Creates a reproducible unique per day identifier for `RealmGuideItem`s.
 It encodes the date, type of item, and remoteID of item in a string. Eg. `20171231#learn#100002`
 - warning: ☠️ This ID is stored on the server. Logic to encode and decode it should remain consistant to avoid
 invalidating existing objects.
*/
struct GuideItemID {

    enum Error: Swift.Error {
        case invalidStringRepresentation
    }

    enum Kind: String {
        case learn
        case notification
    }

    private static var dateFormatter = DateFormatter.guideItemIDFormatter

    let dateString: String
    let kind: Kind
    let remoteID: Int

    init(date: Date, kind: Kind, remoteID: Int) {
        self.dateString = GuideItemID.dateFormatter.string(from: date)
        self.kind = kind
        self.remoteID = remoteID
    }

    init(stringRepresentation: String) throws {
        let componants = stringRepresentation.components(separatedBy: "#")
        guard componants.count == 3, let kind = Kind(rawValue: componants[1]), let remoteID = Int(componants[2]) else {
            throw Error.invalidStringRepresentation
        }

        self.dateString = componants[0]
        self.kind = kind
        self.remoteID = remoteID
    }

    init(date: Date, item: RealmGuideItemLearn) {
        self.init(date: date, kind: .learn, remoteID: item.forcedRemoteID)
    }

    init(date: Date, item: RealmGuideItemNotification) {
        self.init(date: date, kind: .notification, remoteID: item.forcedRemoteID)
    }

    var stringRepresentation: String {
        return "\(dateString)#\(kind.rawValue)#\(remoteID)"
    }
}

private extension DateFormatter {

    static var guideItemIDFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.posix
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }
}
