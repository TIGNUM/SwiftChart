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
public final class ContentCollection: Object, ContentCollectionDataProtocol {

    // MARK: SyncableRealmObject

    public dynamic var remoteID: Int = 0

    public dynamic var _syncStatus: Int8 = 0

    public dynamic var createdAt: Date = Date()

    public dynamic var modifiedAt: Date = Date()

    public let categories: List<ContentCategory> = List()

    public func setData(_ data: ContentCollectionDataProtocol) {
        sortOrder = data.sortOrder
        title = data.title
        layoutInfo = data.layoutInfo
        searchTags = data.searchTags
        relatedContent = data.relatedContent
    }

    // MARK: ContentData

    public private(set) dynamic var sortOrder: Int = 0

    public private(set) dynamic var title: String = ""

    public private(set) dynamic var layoutInfo: String?

    public private(set) dynamic var searchTags: String = ""

    public private(set) dynamic var relatedContent: String?

    // MARK: Realm

    override public class func primaryKey() -> String? {
        return "remoteID"
    }

    // MARK: Relationships

    public let items = LinkingObjects(fromType: ContentItem.self, property: "collection")
}
