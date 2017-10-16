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

    @objc fileprivate(set) dynamic var section: String = ""

    @objc fileprivate(set) dynamic var sortOrder: Int = 0

    @objc fileprivate(set) dynamic var title: String = ""

    @objc fileprivate(set) dynamic var layoutInfo: String?

    @objc fileprivate(set) dynamic var searchTags: String = ""

    @objc fileprivate(set) dynamic var relatedContent: String?

    @objc fileprivate(set) dynamic var thumbnailURLString: String?

    // MARK: Relationships

    let items = List<ContentItem>()

    let contentCategories = List<ContentCategory>()

    // MARK: Computed Properties

    var relatedContentIDs: [Int] {
        guard
            let relatedContent = relatedContent,
            let json = try? JSON(jsonString: relatedContent),
            let ids = try? json.decodedArray(type: Int.self) else {
                return []
        }

        return ids
    }

    var durationString: String {
        let durationString: String

        if hasVideoOnly == true {
            let durations = contentItems.flatMap { $0.valueDuration.value?.toFloat }
            let total = durations.reduce(0) { ($0 / 60) + ($1 / 60) }
            let min = String(Int(total))
            durationString = R.string.localized.learnContentListViewMinutesLabelWatch(min)
        } else {
            let min = String(minutesToRead)
            durationString = R.string.localized.learnContentListViewMinutesLabel(min)
        }

        return durationString
    }

    var hasVideoOnly: Bool {
        let contentItemsVideo = contentItems.filter { $0.format == "video" }

        return contentItemsVideo.count == contentItems.count
    }

    var hasFullItems: Bool {
        let contentItemsFull = contentItems.filter { $0.tabs.contains("FULL") == true }

        return contentItemsFull.isEmpty == false
    }

    var hasBulletItems: Bool {
        let contentItemsBullet = contentItems.filter { $0.tabs.contains("BULLETS") == true }

        return contentItemsBullet.isEmpty == false
    }

    var hasAudioItems: Bool {
        let contentItemsAudio = contentItems.filter { $0.tabs.contains("AUDIO") == true }

        return contentItemsAudio.isEmpty == false
    }
}

// MARK: - BuildRelations

extension ContentCollection: BuildRelations {

    func buildRelations(realm: Realm) {
        let categoryIDs = Array(self.categoryIDs.map({ $0.value }))
        let categories = realm.syncableObjects(ofType: ContentCategory.self, remoteIDs: categoryIDs)
        contentCategories.removeAll()
        contentCategories.append(objectsIn: categories)
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
        section = data.section
        sortOrder = data.sortOrder
        title = data.title
        layoutInfo = data.layoutInfo
        searchTags = data.searchTags
        thumbnailURLString = data.thumbnailURLString
        relatedContent = data.relatedContentIDs

        objectStore.delete(categoryIDs)
        categoryIDs.append(objectsIn: data.categoryIDs.map({ IntObject(int: $0) }))

        if section == Database.Section.learnWhatsHot.rawValue {
            UserDefault.newWhatsHotArticle.setBoolValue(value: true)
        }
    }
}
