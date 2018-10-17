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
final class ContentCategory: SyncableObject {

    // TODO: Remove me please: https://tignum.atlassian.net/browse/IT-553
    @objc dynamic var keypathID: String?

    func setData(_ data: ContentCategoryData) {
        sortOrder = data.sortOrder
        title = data.title
        layoutInfo = data.layoutInfo
    }

    // MARK: ContentData

    @objc private(set) dynamic var sortOrder: Int = 0

    @objc private(set) dynamic var section: String = ""

    @objc private(set) dynamic var title: String = ""

    @objc private(set) dynamic var layoutInfo: String?

    // MARK: Relationships

    let contentCollections = List<ContentCollection>()
}

// MARK: - BuildRelations

extension ContentCategory: BuildRelations {

    func buildInverseRelations(realm: Realm) {
        let predicate = NSPredicate(format: "ANY contentCategories == %@", self)
        let collections = realm.objects(ContentCollection.self).filter(predicate)
        contentCollections.removeAll()
        contentCollections.append(objectsIn: collections)
    }
}

// MARK: - OneWaySyncableDown

extension ContentCategory: OneWaySyncableDown {

    static var endpoint: Endpoint {
        return .contentCategories
    }

    func setData(_ data: ContentCategoryData, objectStore: ObjectStore) throws {
        sortOrder = data.sortOrder
        title = data.title
        layoutInfo = data.layoutInfo
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
