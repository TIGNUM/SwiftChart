//
//  ContentRead.swift
//  QOT
//
//  Created by Sam Wyndham on 02/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import RealmSwift

final class ContentRead: SyncableObject {

    @objc private(set) dynamic var contentCollectionId: Int = 0

    @objc dynamic var viewedAt: Date = Date()

    convenience init(contentCollection: ContentCollection) {
        self.init()
        self.contentCollectionId = contentCollection.forcedRemoteID
        self.viewedAt = Date()
        // The current server implemenatation always makes the remoteID the same as contentCollectionId so lets do the
        // same when we create local versions to ensure we only have one ContentRead per ContentCollection
        self.remoteID.value = contentCollection.forcedRemoteID
    }

    override class func additionalIndexedProperties() -> [String] {
        return ["contentCollectionId"]
    }
}

extension ContentRead: OneWaySyncableDown {

    static var endpoint: Endpoint {
        return .contentRead
    }

    func setData(_ data: ContentReadIntermediary, objectStore: ObjectStore) throws {
        contentCollectionId = data.contentCollectionID
        if data.viewedAt > viewedAt {
            viewedAt = data.viewedAt
        }
    }
}
