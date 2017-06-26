//
//  ContentService.swift
//  QOT
//
//  Created by Sam Wyndham on 24.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class ContentService {

    private let mainRealm: Realm
    private let realmProvider: RealmProvider

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }

    func contentCollections(ids: [Int]) -> AnyRealmCollection<ContentCollection> {
        let predicate = NSPredicate(remoteIDs: ids)
        let results = mainRealm.objects(ContentCollection.self).sorted(byKeyPath: "sortOrder").filter(predicate)
        return AnyRealmCollection(results)
    }

    func contentCollections(categoryID: Int) -> AnyRealmCollection<ContentCollection> {
        let predicate = NSPredicate(format: "ANY categoryIDs.value == %d", categoryID)
        let results = mainRealm.objects(ContentCollection.self).sorted(byKeyPath: "sortOrder").filter(predicate)
        return AnyRealmCollection(results)
    }

    func learnContentCategories() -> AnyRealmCollection<ContentCategory> {
        let predicate = NSPredicate(section: Database.Section.learnStrategy.rawValue)
        let results = mainRealm.objects(ContentCategory.self).sorted(byKeyPath: "sortOrder").filter(predicate)
        return AnyRealmCollection(results)
    }

    func contentCollection(id: Int) -> ContentCollection? {
        return mainRealm.object(ofType: ContentCollection.self, forPrimaryKey: id)
    }

    func contentCategory(id: Int) -> ContentCategory? {
        return mainRealm.object(ofType: ContentCategory.self, forPrimaryKey: id)
    }

    func setViewed(itemID: Int) {
        DispatchQueue.global().async {
            do {
                let realm = try self.realmProvider.realm()
                try realm.write {
                    let contentItem = realm.object(ofType: ContentItem.self, forPrimaryKey: itemID)
                    contentItem?.viewed = true
                }
            } catch let error {
                assertionFailure("UpdateViewedAt, itemId: \(itemID), error: \(error)")
            }
        }
    }
}
