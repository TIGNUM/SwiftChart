//
//  ContentCategory.swift
//  QOT
//
//  Created by Sam Wyndham on 09/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy

// FIXME: Unit test.
public final class ContentCategory: Object, ContentCategoryDataProtocol {

    // MARK: SyncableRealmObject

    public dynamic var remoteID: Int = 0

    public dynamic var _syncStatus: Int8 = 0

    public dynamic var createdAt: Date = Date()

    public dynamic var modifiedAt: Date = Date()

    public func setData(_ data: ContentCategoryDataProtocol) {
        sortOrder = data.sortOrder
        section = data.section
        title = data.title
        layoutInfo = data.layoutInfo
    }

    // MARK: ContentData

    public private(set) dynamic var sortOrder: Int = 0

    public private(set) dynamic var section: String = ""

    public private(set) dynamic var title: String = ""

    public private(set) dynamic var layoutInfo: String?
    
    // MARK: Realm

    override public class func primaryKey() -> String? {
        return "remoteID"
    }

    // MARK: Relationships

    public let contentCollections = LinkingObjects(fromType: ContentCollection.self, property: "categories")
}

extension ContentCategory {

    public func bubbleLayoutInfo() throws -> BubbleLayoutInfo {
        guard let jsonString = layoutInfo else {
            throw QOTDatabaseError.noLayoutInfo
        }

        let json = try JSON(jsonString: jsonString)
        return try BubbleLayoutInfo(json: json)
    }
}

public struct BubbleLayoutInfo: JSONDecodable {

    public let radius: Double
    public let centerX: Double
    public let centerY: Double

    public init(json: JSON) throws {
        radius = try json.getDouble(at: "bubble", "radius")
        centerX = try json.getDouble(at: "bubble", "centerX")
        centerY = try json.getDouble(at: "bubble", "centerY")
    }
}
