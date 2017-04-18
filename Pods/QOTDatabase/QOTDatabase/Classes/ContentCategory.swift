//
//  ContentCategory.swift
//  QOT
//
//  Created by Sam Wyndham on 09/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

// FIXME: Unit test.
public final class ContentCategory: Object, SyncableRealmObject, ContentCategoryData {

    // MARK: SyncableRealmObject

    public let _remoteID: RealmOptional<Int> = RealmOptional()

    public dynamic var _syncStatus: Int8 = 0

    public private(set) dynamic var localID: String = UUID().uuidString

    public dynamic var modifiedAt: Date = Date()

    public var parent: NoParent?

    public func setData(_ data: ContentCategoryData) {
        sortOrder = data.sortOrder
        title = data.title
        radius = data.radius
        centerX = data.centerX
        centerY = data.centerY
    }

    // MARK: ContentData

    public dynamic var sortOrder: Int = 0

    public dynamic var title: String = ""

    public dynamic var radius: Double = 0

    public dynamic var centerX: Double = 0

    public dynamic var centerY: Double = 0
    
    // MARK: Realm

    override public class func primaryKey() -> String? {
        return "localID"
    }

    override public static func indexedProperties() -> [String] {
        return ["_remoteID"]
    }

    // MARK: Relationships

    public let contents = LinkingObjects(fromType: Content.self, property: "parent")
}
