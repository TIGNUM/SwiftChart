//
//  Content.swift
//  QOT
//
//  Created by Sam Wyndham on 09/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import RealmSwift

// FIXME: Unit test.
public final class Content: Object, SyncableRealmObject, ContentData {

    // MARK: SyncableRealmObject

    public let _remoteID: RealmOptional<Int> = RealmOptional()

    public dynamic var _syncStatus: Int8 = 0

    public private(set) dynamic var localID: String = UUID().uuidString

    public dynamic var modifiedAt: Date = Date()

    public dynamic var parent: ContentCategory?

    public func setData(_ data: ContentData) {
        sortOrder = data.sortOrder
        title = data.title
    }

    // MARK: ContentData

    public dynamic var sortOrder: Int = 0

    public dynamic var title: String = ""

    // MARK: Realm

    override public class func primaryKey() -> String? {
        return "localID"
    }

    override public static func indexedProperties() -> [String] {
        return ["_remoteID"]
    }

    // MARK: Relationships

    public let items = LinkingObjects(fromType: ContentItem.self, property: "parent")
}
