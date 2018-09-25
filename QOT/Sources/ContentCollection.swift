//
//  Content.swift
//  QOT
//
//  Created by Sam Wyndham on 09/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import RealmSwift
import Freddy

final class ContentCollection: SyncableObject {

    let categoryIDs: List<IntObject> = List()

    func setData(_ data: ContentCollectionData) {
        section = data.section
        sortOrder = data.sortOrder
        title = data.title
        layoutInfo = data.layoutInfo
        searchTags = data.searchTags
        thumbnailURLString = data.thumbnailURLString
    }

    // MARK: ContentData

    @objc private(set) dynamic var author: String?

    @objc private(set) dynamic var section: String = ""

    @objc private(set) dynamic var sortOrder: Int = 0

    @objc private(set) dynamic var title: String = ""

    @objc private(set) dynamic var layoutInfo: String?

    @objc private(set) dynamic var searchTags: String = ""

    @objc private(set) dynamic var relatedContent: String?

    @objc private(set) dynamic var thumbnailURLString: String?

    @objc dynamic var contentRead: ContentRead?

    // MARK: Relationships

    let items = List<ContentItem>()

    let contentCategories = List<ContentCategory>()

    let relatedContentList = List<ContentRelation>()

    // MARK: Computed Properties

    var viewedAt: Date? {
        return contentRead?.viewedAt
    }

    var relatedContentIDs: [Int] {
        guard
            let relatedContent = relatedContent,
            let json = try? JSON(jsonString: relatedContent),
            let ids = try? json.decodedArray(type: Int.self) else { return [] }
        return ids
    }

    var relatedDefaultContentIDs: [Int] {
        return relatedContentList.filter { $0.type == "PREPARE_DEFAULT" }.compactMap { $0.contentID }
    }

    var durationString: String {
        let durationString: String
        if hasVideoOnly == true {
            let durations = contentItems.compactMap { $0.valueDuration.value?.toFloat }
            let total = durations.reduce(0) { ($0 / 60) + ($1 / 60) }
            let min = String(Int(total))
            durationString = R.string.localized.learnContentListViewMinutesLabelWatch(min)
        } else {
            let min = String(max(minutesToRead, 1))
            durationString = R.string.localized.learnContentListViewMinutesLabel(min)
        }
        return durationString
    }

    var hasVideoOnly: Bool {
        return contentItems.filter { $0.format == "video" }.count == contentItems.count
    }

    var hasFullItems: Bool {
        return contentItems.filter { $0.tabs.contains("FULL") == true }.isEmpty == false
    }

    var hasBulletItems: Bool {
        return contentItems.filter { $0.tabs.contains("BULLETS") == true }.isEmpty == false
    }

    var hasAudioItems: Bool {
        return contentItems.filter { $0.tabs.contains("AUDIO") == true }.isEmpty == false
    }

    var guideTitle: String? {
        return contentItems.filter { $0.format == ContentItemFormat.guideTitle.rawValue }.first?.valueText
    }

    var guideBody: String? {
        return contentItems.filter { $0.format == ContentItemFormat.guideBody.rawValue }.first?.valueText
    }

    var guideType: String? {
        return contentItems.filter { $0.format == ContentItemFormat.guideType.rawValue }.first?.valueText
    }

    var guideFeatureButton: (title: String?, link: URL?) {
        let item = contentItems.filter { $0.format == ContentItemFormat.guideFeatureButton.rawValue }.first
        return (title: item?.valueText, link: URL(string: item?.link ?? ""))
    }
}

// MARK: - BuildRelations

extension ContentCollection: BuildRelations {

    func buildRelations(realm: Realm) {
        let categoryIDs = Array(self.categoryIDs.map({ $0.value }))
        let categories = realm.syncableObjects(ofType: ContentCategory.self, remoteIDs: categoryIDs)
        contentCategories.removeAll()
        contentCategories.append(objectsIn: categories)
        let contentReadPredicate = NSPredicate(format: "contentCollectionId == %d", forcedRemoteID)
        contentRead = realm.objects(ContentRead.self).filter(contentReadPredicate).first
    }

    func buildInverseRelations(realm: Realm) {
        let predicate = NSPredicate(format: "contentCollection == %@", self)
        let items = realm.objects(ContentItem.self).filter(predicate)
        self.items.removeAll()
        self.items.append(objectsIn: items)
    }
}

// MARK: - OneWaySyncableDown

extension ContentCollection: OneWaySyncableDown {

    static var endpoint: Endpoint {
        return .contentCollection
    }

    func setData(_ data: ContentCollectionData, objectStore: ObjectStore) throws {
        author = data.author
        section = data.section
        sortOrder = data.sortOrder
        title = data.title
        layoutInfo = data.layoutInfo
        searchTags = data.searchTags
        thumbnailURLString = data.thumbnailURLString
        relatedContent = data.relatedContentIDs
        objectStore.delete(relatedContentList)
        relatedContentList.append(objectsIn: data.relatedContentList.map({ ContentRelation(intermediary: $0) }))
        objectStore.delete(categoryIDs)
        categoryIDs.append(objectsIn: data.categoryIDs.map({ IntObject(int: $0) }))
    }
}
