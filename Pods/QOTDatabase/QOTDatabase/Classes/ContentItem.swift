//
//  ContentItem.swift
//  QOT
//
//  Created by Sam Wyndham on 09/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

// FIXME: Unit test.
public final class ContentItem: Object, ContentItemDataProtocol {

    // MARK: SyncableRealmObject

    public dynamic var remoteID: Int = 0

    public dynamic var _syncStatus: Int8 = 0

    public dynamic var createdAt: Date = Date()

    public dynamic var modifiedAt: Date = Date()

    public dynamic var collection: ContentCollection?

    public func setData(_ data: ContentItemDataProtocol) throws {
        try data.validate()

        sortOrder = data.sortOrder
        title = data.title
        secondsRequired = data.secondsRequired
        value = data.value
        format = data.format
        viewAt = data.viewAt
        searchTags = data.searchTags
        layoutInfo = data.layoutInfo
    }

    // MARK: ContentData

    public private(set) dynamic var sortOrder: Int = 0

    public private(set) dynamic var title: String = ""

    public private(set) dynamic var secondsRequired: Int = 0

    public private(set) dynamic var value: String = ""

    public private(set) dynamic var format: Int8 = 0

    public private(set) dynamic var searchTags: String = ""

    public private(set) dynamic var layoutInfo: String?

    public dynamic var viewAt: Date?

    // MARK: Realm

    override public class func primaryKey() -> String? {
        return "remoteID"
    }
}

extension ContentItem {

    public func contentItemValue() throws -> ContentItemValue {
        guard let format = ContentItemFormat(rawValue: format) else {
            throw InvalidDataError(data: self)
        }

        return try ContentItemValue(format: format, value: value)
    }
}
