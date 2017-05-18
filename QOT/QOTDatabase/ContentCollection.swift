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
final class ContentCollection: Object, ContentCollectionDataProtocol {

    // MARK: SyncableRealmObject

    dynamic var remoteID: Int = 0

    dynamic var _syncStatus: Int8 = 0

    dynamic var createdAt: Date = Date()

    dynamic var modifiedAt: Date = Date()

    let categories: List<ContentCategory> = List()

    func setData(_ data: ContentCollectionDataProtocol) {
        sortOrder = data.sortOrder
        title = data.title
        layoutInfo = data.layoutInfo
        searchTags = data.searchTags
        relatedContent = data.relatedContent
    }

    // MARK: ContentData

    private(set) dynamic var sortOrder: Int = 0

    private(set) dynamic var title: String = ""

    private(set) dynamic var layoutInfo: String?

    private(set) dynamic var searchTags: String = ""

    private(set) dynamic var relatedContent: String?

    // MARK: Realm

    override class func primaryKey() -> String? {
        return "remoteID"
    }

    // MARK: Relationships

    let items = LinkingObjects(fromType: ContentItem.self, property: "collection")
}
