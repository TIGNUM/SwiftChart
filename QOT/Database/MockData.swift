//
//  MockData.swift
//  QOT
//
//  Created by Sam Wyndham on 10/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

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
    let categoryTitles = [
        "PERFORMANCE MINDSET",
        "PERFORMANCE RECOVERY",
        "PERFORMANCE HABITUATION",
        "PERFORMANCE MOVEMENT",
        "PERFORMANCE NUTRITION",
        "PERFORMANCE MOVEMENT"   
    ]
    
    return categoryTitles.enumerated().map { (index, title) -> ContentCategory in
        let category = ContentCategory(id: newMockID(), sort: index, name: "a name", title: title)
        category.contents.append(objectsIn: mockContent())
        return category
    }
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
