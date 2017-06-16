//
//  MockData+WhatsHot.swift
//  QOT
//
//  Created by karmic on 09.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import LoremIpsum

// MARK: - PrepareContentCategory

func addMockWhatsHotContentCategories(realm: Realm) {
    let categories: [ContentCategory] = [
        mockWhatsHotContentCategory(sortOrder: 0,
                                   title: "QOT Thoughts",
                                   section: Database.Section.learnWhatsHot.rawValue),
        mockWhatsHotContentCategory(sortOrder: 1,
                                    title: "QOT Questions & Answers",
                                    section: Database.Section.learnWhatsHot.rawValue),
        mockWhatsHotContentCategory(sortOrder: 2,
                                    title: "QOT Perspectives",
                                    section: Database.Section.learnWhatsHot.rawValue),
        mockWhatsHotContentCategory(sortOrder: 0,
                                    title: "QOT Essentials",
                                    section: Database.Section.learnWhatsHot.rawValue),
        mockWhatsHotContentCategory(sortOrder: 0,
                                    title: "QOT Insights",
                                    section: Database.Section.learnWhatsHot.rawValue)
    ]

    for category in categories {
        addMockWhatsHotContentCollection(category: category, realm: realm)
    }

    realm.add(categories)
}

private func mockWhatsHotContentCategory(sortOrder: Int, title: String, section: String) -> ContentCategory {
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

private func addMockWhatsHotContentCollection(category: ContentCategory, realm: Realm) {
    var contentCollections = [ContentCollection]()
    let titles = [
        "Harness the power of words into your life.",
        "Harness the power of words into your life.",
        "Harness the power of words into your life.",
        "Harness the power of words into your life.",
        "Harness the power of words into your life.",
        "Harness the power of words into your life.",
        "Harness the power of words into your life.",
        "Harness the power of words into your life."
    ]

    for (index, title) in titles.enumerated() {
        let contentCollection = mockWhatsHotContentCollection(sortOrder: index, title: title)
        contentCollection.categories.append(category)
        contentCollection.remoteID = Int.randomID
        contentCollections.append(contentCollection)
    }

    contentCollections.forEach { (contentCollection: ContentCollection) in
        addMockWhatsHotContentItems(contentCollection: contentCollection, realm: realm)
    }

    realm.add(contentCollections)
}

private func mockWhatsHotContentCollection(sortOrder: Int, title: String) -> ContentCollection {
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

private func addMockWhatsHotContentItems(contentCollection: ContentCollection, realm: Realm) {
    var items: [ContentItem] = []

    for i in 0...Int.random(between: 3, and: 10) {
        let item = mockWhatsHotContentItem(
            sortOrder: i,
            title: LoremIpsum.paragraphs(withNumber: Int.random(between: 3, and: 7))
        )

        item.remoteID = Int.randomID
        item.collection = contentCollection
        items.append(item)
    }

    realm.add(items)
}

private func mockWhatsHotContentItem(sortOrder: Int, title: String) -> ContentItem {
    let contentItem = ContentItem()
    let contentItemData = ContentItemIntermediary(
        sortOrder: sortOrder,
        title: title,
        value: textItemJSON,
        format: ContentItemFormat.textH3.rawValue,
        searchTags: title,
        layoutInfo: nil
    )

    try? contentItem.setData(contentItemData)

    return contentItem
}

private extension ContentItemIntermediary {

    init(sortOrder: Int, title: String, value: String, format: String, searchTags: String, layoutInfo: String?) {
        self.init(
            sortOrder: sortOrder,
            title: title,
            secondsRequired: 0,
            value: value,
            format: format,
            viewed: false,
            searchTags: searchTags,
            layoutInfo: layoutInfo
        )
    }
}
