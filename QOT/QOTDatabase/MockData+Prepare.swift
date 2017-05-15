//
//  MockData+Prepare.swift
//  QOT
//
//  Created by karmic on 12.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - PrepareContentCategory

func addMockPrepareContentCategories(realm: Realm) {
    let categories: [ContentCategory] = [
        mockPrepareContentCategory(sortOrder: 0,
                            title: "PERFOFMANCE MINDSET",
                            section: Database.Section.prepareCoach.rawValue)
    ]

    for category in categories {
        addMockPrepareContentCategory(category: category, realm: realm)
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

private func addMockPrepareContentCategory(category: ContentCategory, realm: Realm) {
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
