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
final class ContentCategory: Object, ContentCategoryDataProtocol {

    // MARK: SyncableRealmObject

    dynamic var remoteID: Int = 0

    dynamic var _syncStatus: Int8 = 0

    dynamic var createdAt: Date = Date()

    dynamic var modifiedAt: Date = Date()

    func setData(_ data: ContentCategoryDataProtocol) {
        sortOrder = data.sortOrder
        section = data.section
        title = data.title
        layoutInfo = data.layoutInfo
    }

    // MARK: ContentData

    fileprivate(set) dynamic var sortOrder: Int = 0

    fileprivate(set) dynamic var section: String = ""

    fileprivate(set) dynamic var keypathID: String?

    fileprivate(set) dynamic var title: String = ""

    fileprivate(set) dynamic var layoutInfo: String?
    
    // MARK: Realm

    override class func primaryKey() -> String? {
        return "remoteID"
    }

    // MARK: Relationships

    let contentCollections = LinkingObjects(fromType: ContentCollection.self, property: "categories")
}

extension ContentCategory: DownSyncable {
    static func make(remoteID: Int, createdAt: Date) -> ContentCategory {
        let category = ContentCategory()
        category.remoteID = remoteID
        category.createdAt = createdAt
        return category
    }

    func setData(_ data: ContentCategoryData, objectStore: ObjectStore) throws {
        sortOrder = data.sortOrder
        section = data.section
        title = data.title
        layoutInfo = data.layoutInfo
    }
}

extension ContentCategory {

    func getBubbleLayoutInfo() throws -> BubbleLayoutInfo {
        guard let jsonString = layoutInfo else {
            throw QOTDatabaseError.noLayoutInfo
        }

        let json = try JSON(jsonString: jsonString)
        return try BubbleLayoutInfo(json: json)
    }

    func getSidebarLayoutInfo() throws -> SidebarLayoutInfo {
        guard let jsonString = layoutInfo else {
            throw QOTDatabaseError.noLayoutInfo
        }

        let json = try JSON(jsonString: jsonString)
        return try SidebarLayoutInfo(json: json)
    }
}

struct BubbleLayoutInfo: JSONDecodable {

    let radius: Double
    let centerX: Double
    let centerY: Double

    init(json: JSON) throws {
        radius = try json.getDouble(at: "bubble", "radius")
        centerX = try json.getDouble(at: "bubble", "centerX")
        centerY = try json.getDouble(at: "bubble", "centerY")
    }
}

struct SidebarLayoutInfo: JSONDecodable {

    let font: UIFont
    let textColor: UIColor
    let cellHeight: CGFloat

    init(json: JSON) throws {
        let red = CGFloat(try json.getDouble(at: Database.ItemKey.textColorRed.value))
        let green = CGFloat(try json.getDouble(at: Database.ItemKey.textColorGreen.value))
        let blue = CGFloat(try json.getDouble(at: Database.ItemKey.textColorBlue.value))
        let alpha = CGFloat(try json.getDouble(at: Database.ItemKey.textColorAlpha.value))
        textColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        font = Font.Name.font(name: try json.getString(at: Database.ItemKey.font.value))
        cellHeight = CGFloat(try json.getDouble(at: Database.ItemKey.cellHeight.value))
    }
}
