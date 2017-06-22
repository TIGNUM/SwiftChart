//
//  LearnContentCategory.swift
//  QOT
//
//  Created by Sam Wyndham on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

protocol LearnContentServiceDelegate: class {
    func updatedViewedAt(with itemID: Int)
}

final class LearnContentService {

    // MARK: - Properties

    private let mainRealm: Realm
    private let realmProvider: RealmProvider
    fileprivate var token: NotificationToken?
    weak var learnCategoryUpdateDelegate: LearnCategoryUpdateDelegate?

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }

    func categories() -> DataProvider<LearnContentCategory> {
        let predicate = NSPredicate(section: Database.Section.learnStrategy.rawValue)
        let results = mainRealm.objects(ContentCategory.self).sorted(byKeyPath: "sortOrder").filter(predicate)
        self.token = mainRealm.addNotificationBlock({ (_, _) in
            self.learnCategoryUpdateDelegate?.didUpdateCategoryViewedPercentage()
        })

        return DataProvider<LearnContentCategory>(items: results, map: { $0 as LearnContentCategory })
    }

    // TODO: That func might become handy also for other services. Modify to generic func.
    func contentCollections(for relatedContentIDs: [Int]) -> DataProvider<LearnContentCollection> {
        let filter = NSPredicate(remoteIDs: relatedContentIDs)
        let results = mainRealm.objects(ContentCollection.self).sorted(byKeyPath: "sortOrder").filter(filter)

        return DataProvider<LearnContentCollection>(items: results, map: { $0 as LearnContentCollection })
    }

    func relatedContentCollections(for categoryID: Int) -> DataProvider<LearnContentCollection> {
        let learnCategory = category(for: categoryID)
        let contenCollectionIDs = learnCategory.learnContent.items.map { $0.remoteID }

        return contentCollections(for: contenCollectionIDs)
    }

    func category(for categoryID: Int) -> LearnContentCategory {
        guard let category = mainRealm.object(ofType: ContentCategory.self, forPrimaryKey: categoryID) else {
            fatalError("No Category found for categoryID: \(categoryID)")
        }

        return category
    }

    func contentCollection(for collectionID: Int) -> LearnContentCollection {
        guard let collection = mainRealm.object(ofType: ContentCollection.self, forPrimaryKey: collectionID) else {
            fatalError("No ContentCollection found for collectionID: \(collectionID)")
        }

        return collection
    }

    func updatedViewedAt(with itemId: Int) {
        DispatchQueue.global().async {
            do {
                let realm = try self.realmProvider.realm()
                try realm.write {
                    let contentItem = realm.object(ofType: ContentItem.self, forPrimaryKey: itemId)
                    contentItem?.viewed = true
                }
            } catch let error {
                assertionFailure("UpdateViewedAt, itemId: \(itemId), error: \(error)")
            }
        }
    }
}
