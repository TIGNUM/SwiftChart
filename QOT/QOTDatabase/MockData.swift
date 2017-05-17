//
//  MockData.swift
//  QOT
//
//  Created by Sam Wyndham on 10/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import LoremIpsum

// FIXME: Remove when no longer needed

/// Deletes all data in default realm and fills with mock data.
func setupRealmWithMockData(realm: Realm) {
    do {
        try realm.write {
            if realm.objects(ContentCategory.self).count == 0 {
                addMockLearnContentCategories(realm: realm)
                addMockPrepareContentCategories(realm: realm)
            }
        }
    } catch let error {
        fatalError("Realm error: \(error)")
    }
}

// MARK: - LearnContentCategory

private func addMockLearnContentCategories(realm: Realm) {
    let categories: [ContentCategory] = [
        mockContentCategory(sortOrder: 0,
                            title: "PERFOFMANCE MINDSET",
                            section: Database.Section.learnStrategy.rawValue,
                            layoutInfo: layoutInfoMindset),
        mockContentCategory(sortOrder: 1,
                            title: "PERFOFMANCE RECOVERY",
                            section: Database.Section.learnStrategy.rawValue,
                            layoutInfo: layoutInfoRecovery),
        mockContentCategory(sortOrder: 2,
                            title: "PERFOFMANCE HABITUATION",
                            section: Database.Section.learnStrategy.rawValue,
                            layoutInfo: layoutInfoHabituation),
        mockContentCategory(sortOrder: 3,
                            title: "PERFOFMANCE MOVEMENT",
                            section: Database.Section.learnStrategy.rawValue,
                            layoutInfo: layoutInfoMovement),
        mockContentCategory(sortOrder: 4,
                            title: "PERFOFMANCE NUTRITION",
                            section: Database.Section.learnStrategy.rawValue,
                            layoutInfo: layoutInfoNutition),
        mockContentCategory(sortOrder: 5,
                            title: "PERFOFMANCE FOUNDATION",
                            section: Database.Section.learnStrategy.rawValue,
                            layoutInfo: layoutInfoFoundation)
    ]

    for category in categories {
        addMockContent(category: category, realm: realm)
    }

    realm.add(categories)
}

private func mockContentCategory(sortOrder: Int, title: String, section: String, layoutInfo: String?) -> ContentCategory {
    let contentCategory = ContentCategory()
    let contentCategoryData = ContentCategoryData(
        sortOrder: sortOrder,
        section: section,
        title: title,
        layoutInfo: layoutInfo
    )
    contentCategory.remoteID = Int.randomID
    contentCategory.setData(contentCategoryData)

    return contentCategory
}

private var layoutInfoMindset: String {
    return "{\"bubble\": {\"radius\": 0.15, \"centerX\": 0.5, \"centerY\": 0.5}}"
}

private var layoutInfoRecovery: String {
    return "{\"bubble\": {\"radius\": 0.131, \"centerX\": 0.32, \"centerY\": 0.24}}"
}

private var layoutInfoHabituation: String {
    return "{\"bubble\": {\"radius\": 0.125, \"centerX\": 0.186, \"centerY\": 0.558}}"
}

private var layoutInfoMovement: String {
    return "{\"bubble\": {\"radius\": 0.131, \"centerX\": 0.442, \"centerY\": 0.804}}"
}

private var layoutInfoNutition: String {
    return "{\"bubble\": {\"radius\": 0.111, \"centerX\": 0.788, \"centerY\": 0.585}}"
}

private var layoutInfoFoundation: String {
    return "{\"bubble\": {\"radius\": 0.139, \"centerX\": 0.716, \"centerY\": 0.250}}"
}

// MARK: - LearnContentCollection

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
    let contents = titles.enumerated().map { (index: Index, title: String) -> ContentCollection in
        let contentCollection = mockContentCollection(sortOrder: index, title: title)
        contentCollection.categories.append(category)
        contentCollection.remoteID = Int.randomID
        return contentCollection
    }

    for content in contents {
        addMockContentItems(content: content, realm: realm)
    }

    realm.add(contents)
}

private func mockContentCollection(sortOrder: Int, title: String) -> ContentCollection {
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

// MARK: - LearnContentItem

private func addMockContentItems(content: ContentCollection, realm: Realm) {
    var items: [ContentItem] = []

    for i in 0...Int.random(between: 3, and: 10) {
        let item = mockContentItem(
            sortOrder: i,
            title: LoremIpsum.paragraphs(withNumber: Int.random(between: 3, and: 7)),
            secondsRequired: Int.random(between: 30, and: 240)
        )

        item.remoteID = Int.randomID
        item.collection = content
        items.append(item)
    }

    realm.add(items)
}

private func mockContentItem(sortOrder: Int, title: String, secondsRequired: Int) -> ContentItem {
    let contentItem = ContentItem()
    let randomContentItemFormatFormat = Int8(Int.random(between: 0, and: 4))
    let randomContentItemFormat = ContentItemFormat(rawValue: randomContentItemFormatFormat)
    let contentItemData = ContentItemData(
        sortOrder: sortOrder,
        title: title,
        secondsRequired: secondsRequired,
        value: randomItemJson(format: randomContentItemFormat),
        format: randomContentItemFormatFormat,
        viewAt: nil,
        searchTags: title,
        layoutInfo: ""
    )
    try? contentItem.setData(contentItemData)

    return contentItem
}

private func randomItemJson(format: ContentItemFormat?) -> String {
    guard let format = format else {
        return textItemJSON
    }

    switch format {
    case .audio: return audioItemJSON
    case .bullet: return bulletItemJSON
    case .image: return imageItemJSON
    case .text: return textItemJSON
    case .video: return videoItemJSON
    }
}

var textItemJSON: String {
    var dict: [String: Any] = [:]
    dict["text"] = LoremIpsum.sentences(withNumber: Int.random(between: 5, and: 15))

    return jsonDictToString(dict: dict)
}

private var videoItemJSON: String {
    var dict: [String: Any] = [:]
    dict["title"] = LoremIpsum.words(withNumber: Int.random(between: 3, and: 10))
    dict["description"] = LoremIpsum.words(withNumber: Int.random(between: 5, and: 10))
    dict["placeholderURL"] = LoremIpsum.urlForPlaceholderImage(with: CGSize(width: 200, height: 300)).absoluteString
    dict["videoURL"] = LoremIpsum.url().absoluteString
    dict["duration"] = Int.random(between: 100, and: 1000)

    return jsonDictToString(dict: dict)
}

private var audioItemJSON: String {
    var dict: [String: Any] = [:]
    dict["title"] = LoremIpsum.words(withNumber: Int.random(between: 3, and: 10))
    dict["description"] = LoremIpsum.words(withNumber: Int.random(between: 5, and: 10))
    dict["placeholderURL"] = LoremIpsum.urlForPlaceholderImage(with: CGSize(width: 200, height: 300)).absoluteString
    dict["audioURL"] = LoremIpsum.url().absoluteString
    dict["duration"] = Int.random(between: 100, and: 1000)
    dict["waveformData"] = waveformData()

    return jsonDictToString(dict: dict)
}

private var imageItemJSON: String {
    var dict: [String: Any] = [:]
    dict["title"] = LoremIpsum.words(withNumber: Int.random(between: 3, and: 10))
    dict["description"] = LoremIpsum.words(withNumber: Int.random(between: 5, and: 10))
    dict["url"] = LoremIpsum.urlForPlaceholderImage(with: CGSize(width: 200, height: 300)).absoluteString

    return jsonDictToString(dict: dict)
}

private var bulletItemJSON: String {
    return textItemJSON
}

private func waveformData() -> [Float] {
    var waveformData = [Float]()

    for _ in 0...Int.random(between: 1000, and: 9999) {
        waveformData.append(Float(Int.random(between: 100, and: 999) / 1000))
    }

    return waveformData
}

func jsonDictToString(dict: [String: Any]) -> String {
    if
        let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
        let string = String(data: data, encoding: .utf8) {
            return string
    } else {
        fatalError("Could not create textItemJSON!")
    }
}

// MARK: - Extensions

extension Int {
    /// Returns random number from `min` to `max` exclusive.
    static func random(between min: Int, and max: Int) -> Int {
        assert(min < max)
        return Int(arc4random_uniform(UInt32(max) - UInt32(min))) + min
    }

    static var randomID: Int {
        return Int.random(between: 100000000, and: 999999999)
    }
}

private extension Array {
    func randomItem() -> Element {
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }
}
