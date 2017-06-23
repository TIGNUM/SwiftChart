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
    fileprivate let articleHeader: ArticleCollectionHeader
    fileprivate let relatedArticles: DataProvider<ArticleContentCollection>
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var itemCount: Int {
        return items.count
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
