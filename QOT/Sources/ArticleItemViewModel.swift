//
//  ArticleItemViewModel.swift
//  QOT
//
//  Created by karmic on 22.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class ArticleItemViewModel {

    fileprivate let items: [ArticleContentItem]
    fileprivate let relatedArticles: DataProvider<ArticleContentCollection>
    let articleHeader: ArticleCollectionHeader
    let updates = PublishSubject<CollectionUpdate, NoError>()

    func itemCount(in section: Index) -> Int {
        return section == 0 ? items.count : 1
    }

    var sectionCount: Int {
        return relatedArticles.count > 0 ? 2 : 1
    }

    func articleItem(at indexPath: IndexPath) -> ArticleContentItem {
        return items[indexPath.row]
    }

    // MARK: - Init

    init(items: DataProvider<ArticleContentItem>,
         articleHeader: ArticleCollectionHeader,
         relatedArticles: DataProvider<ArticleContentCollection>) {
            self.articleHeader = articleHeader
            self.relatedArticles = relatedArticles
            self.items = items.items.sorted(by: { (lhs: ArticleContentItem, rhs: ArticleContentItem) -> Bool in
                return lhs.sortOrder < rhs.sortOrder
            })
    }
}
