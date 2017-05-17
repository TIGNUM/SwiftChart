//
//  MockData+Prepare.swift
//  QOT
//
//  Created by karmic on 12.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import LoremIpsum

// MARK: - PrepareContentCategory

func addMockPrepareContentCategories(realm: Realm) {
    let categories: [ContentCategory] = [
        mockPrepareContentCategory(sortOrder: 0,
                            title: "PERFOFMANCE MINDSET",
                            section: Database.Section.prepareCoach.rawValue)
    ]

    for category in categories {
        addMockPrepareContentCollection(category: category, realm: realm)
    }

    realm.add(categories)
}

private func mockPrepareContentCategory(sortOrder: Int, title: String, section: String) -> ContentCategory {
    let contentCategory = ContentCategory()
    let contentCategoryData = ContentCategoryData(
        sortOrder: sortOrder,
        section: section,
        title: title,
        layoutInfo: nil
    )

    contentCategory.remoteID = Int.randomID
    contentCategory.setData(contentCategoryData)

    return contentCategory
}

// MARK: - PrepareContentCollection

private func addMockPrepareContentCollection(category: ContentCategory, realm: Realm) {
    var contentCollections = [ContentCollection]()
    let titles = [
        "Meeting",
        "Negotiation",
        "Presentation",
        "Business Dinner",
        "Pre-Vacation",
        "Work to home transition"
    ]

    for (index, title) in titles.enumerated() {
        let contentCollection = mockPrepareContentCollection(sortOrder: index, title: title)
        contentCollection.categories.append(category)
        contentCollection.remoteID = Int.randomID
        contentCollections.append(contentCollection)
    }

    contentCollections.forEach { (contentCollection: ContentCollection) in
        addMockPrepareContentItems(contentCollection: contentCollection, realm: realm)
    }

    realm.add(contentCollections)
}

private func mockPrepareContentCollection(sortOrder: Int, title: String) -> ContentCollection {
    let contentCollection = ContentCollection()
    let contentCollectionData = ContentCollectionData(
        sortOrder: sortOrder,
        title: title,
        layoutInfo: nil,
        searchTags: title,
        relatedContent: nil
    )
    contentCollection.setData(contentCollectionData)

    return contentCollection
}

// MARK: - PrepareContentItems

private func addMockPrepareContentItems(contentCollection: ContentCollection, realm: Realm) {
    var items: [ContentItem] = []

    for i in 0...Int.random(between: 3, and: 10) {
        let item = mockPrepareContentItem(
            sortOrder: i,
            title: LoremIpsum.paragraphs(withNumber: Int.random(between: 3, and: 7))
        )

        item.remoteID = Int.randomID
        item.collection = contentCollection
        items.append(item)
    }

    realm.add(items)
}

private func mockPrepareContentItem(sortOrder: Int, title: String) -> ContentItem {
    let contentItem = ContentItem()
    let contentItemData = ContentItemData(
        sortOrder: sortOrder,
        title: title,
        value: textItemJSON,
        format: ContentItemFormat.text.rawValue,
        searchTags: title,
        layoutInfo: (sortOrder == 1 || sortOrder == 2 || sortOrder == 3) ? prepareContentItemLayoutInfo : nil
    )
    
    try? contentItem.setData(contentItemData)

    return contentItem
}

private var prepareContentItemLayoutInfo: String {
    var dict: [String: Any] = [:]
    dict["accordionTitle"] = LoremIpsum.name()

    return jsonDictToString(dict: dict)
}

private extension ContentItemData {

    init(sortOrder: Int, title: String, value: String, format: Int8, searchTags: String, layoutInfo: String?) {
        self.init(
            sortOrder: sortOrder,
            title: title,
            secondsRequired: 0,
            value: value,
            format: format,
            viewAt: nil,
            searchTags: searchTags,
            layoutInfo: layoutInfo
        )
    }
}
