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
    fileprivate let relatedArticles: AnyRealmCollection<ContentCollection>
    let articleHeader: ArticleCollectionHeader
    let updates = PublishSubject<CollectionUpdate, NoError>()

    func itemCount(in section: Index) -> Int {
        return section == 0 ? items.count : 1
    }

    var sectionCount: Int {
        return relatedArticles.count > 0 ? 2 : 1
    }

    func articleItem(at indexPath: IndexPath) -> ContentItem {
        return items[indexPath.row]
    }

    // MARK: - Init

    init(items: AnyRealmCollection<ContentItem>,
         articleHeader: ArticleCollectionHeader,
         relatedArticles: AnyRealmCollection<ContentCollection>) {
            self.articleHeader = articleHeader
            self.relatedArticles = relatedArticles
            self.items = items.sorted(by: { (lhs: ContentItem, rhs: ContentItem) -> Bool in
                return lhs.sortOrder < rhs.sortOrder
            })
    }
}
