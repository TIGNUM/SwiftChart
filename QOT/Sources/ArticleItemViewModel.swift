//
//  ArticleItemViewModel.swift
//  QOT
//
//  Created by karmic on 22.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveKit

final class ArticleItemViewModel {

    fileprivate let items: [ContentItem]
    fileprivate let relatedArticles: [ContentCollection]
    let articleHeader: ArticleCollectionHeader?
    let updates = PublishSubject<CollectionUpdate, NoError>()

    func itemCount(in section: Index) -> Int {
        switch section {
        case 0: return items.count
        case 1: return relatedArticles.count > 3 ? 3 : relatedArticles.count
        default: return 0
        }
    }

    var sectionCount: Int {
        return relatedArticles.count > 0 ? 2 : 1
    }

    func articleItem(at indexPath: IndexPath) -> ContentItem {
        return items[indexPath.row]
    }

    func relatedArticle(at indexPath: IndexPath) -> ContentCollection {
        return relatedArticles[indexPath.row]
    }

    // MARK: - Init

    init(items: [ContentItem],
         contentCollection: ContentCollection,
         articleHeader: ArticleCollectionHeader?,
         relatedArticles: [ContentCollection]) {
            self.articleHeader = articleHeader
            self.relatedArticles = relatedArticles.sorted(by: { (lhs: ContentCollection, rhs: ContentCollection) -> Bool in
                return lhs.sortOrder < rhs.sortOrder
            })

            self.items = items.sorted(by: { (lhs: ContentItem, rhs: ContentItem) -> Bool in
                    return lhs.sortOrder < rhs.sortOrder
            })
    }
}
