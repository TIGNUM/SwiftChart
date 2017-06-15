//
//  Page.swift
//  QOT
//
//  Created by Sam Wyndham on 15.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class Page: Object {

    // MARK: SyncableRealmObject

    dynamic var remoteID: Int = 0

    dynamic var _syncStatus: Int8 = 0

    dynamic var createdAt: Date = Date()

    dynamic var modifiedAt: Date = Date()

    // MARK: Data

    fileprivate(set) dynamic var name: String = ""

    /// The display name in the Admin Tool. We might not use this in the app.
    fileprivate(set) dynamic var displayName: String?

    fileprivate(set) dynamic var layoutInfo: String?

    // MARK: Relationships

    // FIXME: Implement settings relationship
}

extension Page: DownSyncable {
    static func make(remoteID: Int, createdAt: Date) -> Page {
        let page = Page()
        page.remoteID = remoteID
        page.createdAt = createdAt
        return page
    }

    func setData(_ data: PageIntermediary, objectStore: ObjectStore) throws {
        name = data.name
        displayName = data.displayName
        layoutInfo = data.layoutInfo
    }
}
