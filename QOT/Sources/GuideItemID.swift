//
//  GuideItemID.swift
//  QOT
//
//  Created by Sam Wyndham on 19.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

struct GuideItemID {

    enum Error: Swift.Error {
        case invalidStringRepresentation
    }

    enum Kind: String {
        case learn
        case notification
    }

    let kind: Kind
    let remoteID: Int

    init(kind: Kind, remoteID: Int) {
        self.kind = kind
        self.remoteID = remoteID
    }

    init(stringRepresentation: String) throws {
        let componants = stringRepresentation.components(separatedBy: "#")
        guard componants.count == 2, let kind = Kind(rawValue: componants[0]), let remoteID = Int(componants[1]) else {
            throw Error.invalidStringRepresentation
        }

        self.kind = kind
        self.remoteID = remoteID
    }

    init(item: RealmGuideItemLearn) {
        self.init(kind: .learn, remoteID: item.forcedRemoteID)
    }

    init(item: RealmGuideItemNotification) {
        self.init(kind: .notification, remoteID: item.forcedRemoteID)
    }

    var stringRepresentation: String {
        return "\(kind.rawValue)#\(remoteID)"
    }
}
