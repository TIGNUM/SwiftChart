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
                realm.add(mockContentCategories())
            }
        }
    } catch let error {
        fatalError("Realm error: \(error)")
    }
}

private var mockID = 0

private func newMockID() -> Int {
    let id = mockID
    mockID += 1
    return id
}

private func mockContentItems() -> [ContentItem] {
    let datas: [ContentItem.Data] = [.text("some text"), .video(URL(string: "a_url")!)]
    var items: [ContentItem] = []
    for i in 0...Int.random(between: 3, and: 10) {
        let status = ContentItem.Status.notViewed
        let item = ContentItem(id: newMockID(), sort: i, title: "", status: status, data: datas.randomItem())
        items.append(item)
    }
    return items
}

private func mockContent() -> [Content] {
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
    return titles.enumerated().map { (index, title) -> Content in
        let content = Content(id: newMockID(), sort: index, name: "some name", title: title)
        content.items.append(objectsIn: mockContentItems())
        return content
    }
}
private func mockContentCategories() -> [ContentCategory] {
    let categories: [ContentCategory] = [
        ContentCategory(id: newMockID(), sort: 0, name: "a name", title: "PERFOFMANCE MINDSET", radius: 0.15, centerX: 0.5, centerY: 0.5),
        ContentCategory(id: newMockID(), sort: 1, name: "a name", title: "PERFORMANCE RECOVERY", radius: 0.131, centerX: 0.32, centerY: 0.24),
        ContentCategory(id: newMockID(), sort: 2, name: "a name", title: "PERFORMANCE HABITUATION", radius: 0.125, centerX: 0.186, centerY: 0.558),
        ContentCategory(id: newMockID(), sort: 3, name: "a name", title: "PERFORMANCE MOVEMENT", radius: 0.131, centerX: 0.442, centerY: 0.804),
        ContentCategory(id: newMockID(), sort: 4, name: "a name", title: "PERFORMANCE NUTRITION", radius: 0.111, centerX: 0.788, centerY: 0.585),
        ContentCategory(id: newMockID(), sort: 5, name: "a name", title: "PERFORMANCE MOVEMENT", radius: 0.139, centerX: 0.716, centerY: 0.250)
    ]
    categories.forEach { (category) in
        category.contents.append(objectsIn: mockContent())
    }
    return categories
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
