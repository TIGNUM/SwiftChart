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

    // TODO: Remove me please: https://tignum.atlassian.net/browse/IT-553
    dynamic var keypathID: String?

    func setData(_ data: ContentCategoryDataProtocol) {
        sortOrder = data.sortOrder
        section = data.section
        title = data.title
        layoutInfo = data.layoutInfo
    }

    // MARK: ContentData

    fileprivate(set) dynamic var sortOrder: Int = 0

    fileprivate(set) dynamic var section: String = ""

    fileprivate(set) dynamic var title: String = ""

    fileprivate(set) dynamic var layoutInfo: String?
    
    // MARK: Realm

    override class func primaryKey() -> String? {
        return "remoteID"
    }

    // MARK: Relationships

    lazy var contentCollections: Results<ContentCollection> = {
        guard let realm = self.realm else {
            preconditionFailure("Attempted to access contentCollections on an unmanaged ContentCategory: \(self)")
        }

        let predicate = NSPredicate(format: "ANY categoryIDs.value == %d", self.remoteID)
        return realm.objects(ContentCollection.self).filter(predicate)
    }()
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

    var bubbleLayoutInfo: BubbleLayoutInfo {
        guard
            let jsonString = layoutInfo,
            let json = try? JSON(jsonString: jsonString),
            let info = try? BubbleLayoutInfo(json: json)
            else {
                return BubbleLayoutInfo.invalid
        }

        return info
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

    init(radius: Double = 0.2, centerX: Double = 0.2, centerY: Double = 0.2) {
        self.radius = radius
        self.centerX = centerX
        self.centerY = centerY
    }

    init(json: JSON) throws {
        radius = try json.getDouble(at: "bubble", "radius")
        centerX = try json.getDouble(at: "bubble", "centerX")
        centerY = try json.getDouble(at: "bubble", "centerY")
    }

    static var invalid: BubbleLayoutInfo {
        return BubbleLayoutInfo()
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
