//
//  ArticleService.swift
//  QOT
//
//  Created by karmic on 09.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

protocol ArticleServiceDelegate: class {

    func didSelectItem(with itemID: Int, from viewController: UIViewController)
}

final class ArticleService {

    // MARK: - Properties

    private let mainRealm: Realm
    private let realmProvider: RealmProvider
    fileprivate var token: NotificationToken?

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }

    func categories() -> DataProvider<ArticleContentCategory> {
        let predicate = NSPredicate(section: Database.Section.learnWhatsHot.rawValue)
        let results = mainRealm.objects(ContentCategory.self).sorted(byKeyPath: JsonKey.sortOrder.value).filter(predicate)
        
        return DataProvider<ArticleContentCategory>(items: results, map: { $0 as ArticleContentCategory })
    }

    func contentCollections(for categories: DataProvider<ArticleContentCategory>) -> [ArticleContentCollection] {
        var articleCollections = [ArticleContentCollection]()

        categories.items.forEach { (category: ArticleContentCategory) in
            articleCollections.append(contentsOf: category.articleContent.items)
        }

        return articleCollections
    }

    func relatedArticles(for articleCollection: ArticleContentCollection) -> DataProvider<ArticleContentCollection> {
        let predicate = NSPredicate(remoteIDs: articleCollection.relatedContentIDs)
        let results = mainRealm.objects(ContentCollection.self).sorted(byKeyPath: JsonKey.sortOrder.value).filter(predicate)

        return DataProvider<ArticleContentCollection>(items: results, map: { $0 as ArticleContentCollection })
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
