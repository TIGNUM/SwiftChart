//
//  MockData+Sidebar.swift
//  QOT
//
//  Created by karmic on 16.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import LoremIpsum

func addMockSidebarContentCategories(realm: Realm) {
    let categories: [ContentCategory] = [
        mockContentCategory(sortOrder: 0,
                            title: R.string.localized.sidebarTitleLibrary(),
                            section: Database.Section.sidebar.rawValue,
                            keypathID: Database.Section.Sidebar.library.value,
                            layoutInfo: layoutInfo(font: "h2SecondaryTitle", red: 1, green: 1, blue: 1, alpha: 1, cellHeight: 75)
        ),
        mockContentCategory(sortOrder: 1,
                            title: R.string.localized.sidebarTitleBenefits(),
                            section: Database.Section.sidebar.rawValue,
                            keypathID: Database.Section.Sidebar.benefits.value,
                            layoutInfo: layoutInfo(font: "h2SecondaryTitle", red: 1, green: 1, blue: 1, alpha: 1, cellHeight: 75)
        ),
        mockContentCategory(sortOrder: 2,
                            title: R.string.localized.sidebarTitleSettings(),
                            section: Database.Section.sidebar.rawValue,
                            keypathID: Database.Section.Sidebar.settings.value,
                            layoutInfo: layoutInfo(font: "h2SecondaryTitle", red: 1, green: 1, blue: 1, alpha: 1, cellHeight: 75)
        ),
        mockContentCategory(sortOrder: 3,
                            title: R.string.localized.sidebarTitleSensor(),
                            section: Database.Section.sidebar.rawValue,
                            keypathID: Database.Section.Sidebar.sensor.value,
                            layoutInfo: layoutInfo(font: "h2SecondaryTitle", red: 1, green: 1, blue: 1, alpha: 1, cellHeight: 75)
        ),
        mockContentCategory(sortOrder: 4,
                            title: R.string.localized.sidebarTitleAbout(),
                            section: Database.Section.sidebar.rawValue,
                            keypathID: Database.Section.Sidebar.about.value,
                            layoutInfo: layoutInfo(font: "h5SecondaryHeadline", red: 1, green: 1, blue: 1, alpha: 0.4, cellHeight: 65)
        ),
        mockContentCategory(sortOrder: 5,
                            title: R.string.localized.sidebarTitlePrivacy(),
                            section: Database.Section.sidebar.rawValue,
                            keypathID: Database.Section.Sidebar.privacy.value,
                            layoutInfo: layoutInfo(font: "h5SecondaryHeadline", red: 1, green: 1, blue: 1, alpha: 0.4, cellHeight: 65)
        ),
        mockContentCategory(sortOrder: 6,
                            title: R.string.localized.sidebarTitleLogout(),
                            section: Database.Section.sidebar.rawValue,
                            keypathID: Database.Section.Sidebar.logout.value,
                            layoutInfo: layoutInfo(font: "h5SecondaryHeadline", red: 1, green: 1, blue: 1, alpha: 0.4, cellHeight: 65)
        )
    ]

    for category in categories {
        addMockContentCollection(category: category, realm: realm)
    }
    
    realm.add(categories)
}

private func mockContentCategory(sortOrder: Int, title: String, section: String, keypathID: String?, layoutInfo: String?) -> ContentCategory {
    let contentCategory = ContentCategory()
    let contentCategoryData = ContentCategoryData(
        sortOrder: sortOrder,
        section: section,
        title: title,
        layoutInfo: layoutInfo
    )
    contentCategory.remoteID = Int.randomID
    contentCategory.keypathID = keypathID
    contentCategory.setData(contentCategoryData)

    return contentCategory
}

// MARK: - SidebarContentCollection

private func addMockContentCollection(category: ContentCategory, realm: Realm) {
    guard let collectionSection = category.keypathID else {
        return
    }

    var contentCollections = [ContentCollection]()

    switch collectionSection {
    case Database.Section.Sidebar.library.value: break
    case Database.Section.Sidebar.benefits.value:
        let sidebarContentCollection = mockSidebarCollection(
            sortOrder: category.sortOrder,
            title: category.title,
            section: Database.Section.Sidebar.benefits.value,
            realm: realm
        )
        sidebarContentCollection.categoryIDs.append(IntObject(int: category.remoteID))
        contentCollections.append(sidebarContentCollection)

    case Database.Section.Sidebar.settings.value: break
    case Database.Section.Sidebar.sensor.value: break
    case Database.Section.Sidebar.about.value:
        let sidebarContentCollection = mockSidebarCollection(
            sortOrder: category.sortOrder,
            title: category.title,
            section: Database.Section.Sidebar.about.value,
            realm: realm
        )
        sidebarContentCollection.categoryIDs.append(IntObject(int: category.remoteID))
        contentCollections.append(sidebarContentCollection)
    case Database.Section.Sidebar.privacy.value:
        let sidebarContentCollection = mockSidebarCollection(
            sortOrder: category.sortOrder,
            title: category.title,
            section: Database.Section.Sidebar.privacy.value,
            realm: realm
        )
        sidebarContentCollection.categoryIDs.append(IntObject(int: category.remoteID))
        contentCollections.append(sidebarContentCollection)

    case Database.Section.Sidebar.logout.value: break
    default: return
    }

    realm.add(contentCollections)
}

private func mockSidebarCollection(sortOrder: Int, title: String, section: String, realm: Realm) -> ContentCollection {
    let contentCollection = ContentCollection()
    let contentCollectionData = ContentCollectionData(
        sortOrder: sortOrder,
        title: title,
        layoutInfo: nil,
        searchTags: title,
        relatedContent: nil
    )
    contentCollection.remoteID = Int.randomID
    contentCollection.setData(contentCollectionData)
    addMockSidebarContentItems(contentCollection: contentCollection, realm: realm)

    return contentCollection
}

// MARK: - SidebarContentItems

private func addMockSidebarContentItems(contentCollection: ContentCollection, realm: Realm) {
    var benefitsContentItems = [ContentItem]()

    for index in 0...8 {
        let benefitsContentItem = mockSidebarContentItem(sortOrder: index, title: LoremIpsum.name())
        benefitsContentItem.remoteID = Int.randomID
        benefitsContentItem.collectionID.value = contentCollection.remoteID
        benefitsContentItems.append(benefitsContentItem)
    }

    realm.add(benefitsContentItems)
}

private func mockSidebarContentItem(sortOrder: Int, title: String) -> ContentItem {
    let contentItem = ContentItem()
    let randomContentItemFormatFormat = ContentItemFormat.randomItemFormat
    let randomContentItemFormat = ContentItemFormat(rawValue: randomContentItemFormatFormat.rawValue)
    let contentItemData = ContentItemIntermediary(
        sortOrder: sortOrder,
        title: title,
        secondsRequired: Int.random(between: 30, and: 240),
        value: randomItemJson(format: randomContentItemFormat),
        format: randomContentItemFormatFormat.rawValue,
        viewed: false,
        searchTags: title,
        layoutInfo: ""
    )
    try? contentItem.setData(contentItemData)

    return contentItem
}

// MARK: - LayoutInfo

private func layoutInfo (
    font: String,
    red: CGFloat,
    green: CGFloat,
    blue: CGFloat,
    alpha: CGFloat,
    cellHeight: CGFloat) -> String {
        var dict: [String: Any] = [:]
        dict[Database.ItemKey.font.value] = font
        dict[Database.ItemKey.textColorRed.value] = red
        dict[Database.ItemKey.textColorGreen.value] = green
        dict[Database.ItemKey.textColorBlue.value] = blue
        dict[Database.ItemKey.textColorAlpha.value] = alpha
        dict[Database.ItemKey.cellHeight.value] = cellHeight

        return jsonDictToString(dict: dict)
}

// MARK: - JSON

private func randomItemJson(format: ContentItemFormat?) -> String {
    guard let format = format else {
        return textItemJSON
    }

    switch format {
    case .audio: return audioItemJSON
    case .image: return imageItemJSON
    case .video: return videoItemJSON
    case .textH1,
         .textH2,
         .textH3,
         .textH4,
         .textH5,
         .textH6,
         .listItem,
         .textQuote,
         .textParagraph: return textItemJSON
    }
}

private var videoItemJSON: String {
    var dict: [String: Any] = [:]
    dict["title"] = LoremIpsum.words(withNumber: Int.random(between: 3, and: 10))
    dict["description"] = LoremIpsum.words(withNumber: Int.random(between: 5, and: 10))
    dict["thumbnailURL"] = LoremIpsum.urlForPlaceholderImage(with: CGSize(width: 200, height: 300)).absoluteString
    dict["videoURL"] = LoremIpsum.url().absoluteString
    dict["duration"] = Int.random(between: 100, and: 1000)

    return jsonDictToString(dict: dict)
}

private var audioItemJSON: String {
    var dict: [String: Any] = [:]
    dict["title"] = LoremIpsum.words(withNumber: Int.random(between: 3, and: 10))
    dict["description"] = LoremIpsum.words(withNumber: Int.random(between: 5, and: 10))
    dict["thumbnailURL"] = LoremIpsum.urlForPlaceholderImage(with: CGSize(width: 200, height: 300)).absoluteString
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

private func waveformData() -> [Float] {
    var waveformData = [Float]()

    for _ in 0...Int.random(between: 1000, and: 9999) {
        waveformData.append(Float(Int.random(between: 100, and: 999) / 1000))
    }

    return waveformData
}
