//
//  MockData.swift
//  QOT
//
//  Created by Sam Wyndham on 10/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import QOTDatabase

// FIXME: Remove when no longer needed

/// Deletes all data in default realm and fills with mock data.
func setupRealmWithMockData(realm: Realm) {
    do {
        try realm.write {
            if realm.objects(ContentCategory.self).count ==  0 {
                addMockContentCategories(realm: realm)
            }
        }
    } catch let error {
        fatalError("Realm error: \(error)")
    }
}

private func addMockContentCategories(realm: Realm) {
    let categories: [ContentCategory] = [
        mockContentCategory(sort: 0, title: "PERFOFMANCE MINDSET", radius: 0.15, centerX: 0.5, centerY: 0.5),
        mockContentCategory(sort: 1, title: "PERFORMANCE RECOVERY", radius: 0.131, centerX: 0.32, centerY: 0.24),
        mockContentCategory(sort: 2, title: "PERFORMANCE HABITUATION", radius: 0.125, centerX: 0.186, centerY: 0.558),
        mockContentCategory(sort: 3, title: "PERFORMANCE MOVEMENT", radius: 0.131, centerX: 0.442, centerY: 0.804),
        mockContentCategory(sort: 4, title: "PERFORMANCE NUTRITION", radius: 0.111, centerX: 0.788, centerY: 0.585),
        mockContentCategory(sort: 5, title: "PERFORMANCE MOVEMENT", radius: 0.139, centerX: 0.716, centerY: 0.250)
    ]

    realm.add(categories)

    for category in categories {
        addMockContent(category: category, realm: realm)
    }
}

private func addMockContent(category: ContentCategory, realm: Realm) {
    let possibleTitles = [
        "Performance mindset defined",
        "Identify Mindset Killers",
        "Eliminate Drama",
        "From Low To High Performance",
        "Optimal Performance State",
        "Mindset Shift",
        "Building on High Performance",
        "Reframe Thoughts",
        "Visulize Success",
        "Control the Controllable",
        "Mental Rehearsal",
        "Set Intentions",
        "Performance Mindset Defined"
    ]

    let titles = possibleTitles.prefix(upTo: Int.random(between: 3, and: possibleTitles.count + 1))

    let contents = titles.enumerated().map { (index, title) -> Content in
        let content = mockContent(sort: index, title: title)
        content.parent = category
        return content
    }
    realm.add(contents)

    for content in contents {
        addMockContentItems(content: content, realm: realm)
    }
}

private func addMockContentItems(content: Content, realm: Realm) {
    let values: [ContentItemValue] = [.text("some text"), .video(URL(string: "a_url")!)]
    var items: [ContentItem] = []
    for i in 0...Int.random(between: 3, and: 10) {
        let item = mockContentItem(sort: i, title: "", secondsRequired: Int.random(between: 30, and: 240), value: values.randomItem(), status: .notViewed)
        item.parent = content
        items.append(item)
    }
    realm.add(items)
}

private func mockContentCategory(sort: Int, title: String, radius: Double, centerX: Double, centerY: Double) -> ContentCategory {
    let category = ContentCategory()
    category.sortOrder = sort
    category.title = title
    category.radius = radius
    category.centerX = centerX
    category.centerY = centerY

    return category
}

private func mockContent(sort: Int, title: String) -> Content {
    let content = Content()
    content.sortOrder = sort
    content.title = title

    return content
}

private func mockContentItem(sort: Int, title: String, secondsRequired: Int, value: ContentItemValue, status: ContentItemStatus) -> ContentItem {
    let item = ContentItem()
    item.sortOrder = sort
    item.title = title
    item.secondsRequired = secondsRequired
    item.value =  value
    item.status = status

    return item
}

private extension Array {
    func randomItem() -> Element {
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }
}

private extension Int {
    /// Returns random number from `min` to `max` exclusive.
    static func random(between min: Int, and max: Int) -> Int {
        assert(min < max)
        return Int(arc4random_uniform(UInt32(max) - UInt32(min))) + min
    }
}
