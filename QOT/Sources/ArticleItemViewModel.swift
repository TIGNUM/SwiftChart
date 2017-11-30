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

    private let items: [ContentItem]
    private let relatedArticles: [ContentCollection]
    let backgroundImage: UIImage?
    let articleHeader: ArticleCollectionHeader?
    let contentCollection: ContentCollection

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

    init(services: Services,
         items: [ContentItem],
         contentCollection: ContentCollection,
         articleHeader: ArticleCollectionHeader?,
         backgroundImage: UIImage? = nil) {
        self.articleHeader = articleHeader
        self.backgroundImage = backgroundImage
        self.contentCollection = contentCollection

        let relatedArticles = services.contentService.relatedArticles(for: contentCollection)
        self.relatedArticles = relatedArticles.sorted(by: { (lhs: ContentCollection, rhs: ContentCollection) -> Bool in
            return lhs.sortOrder < rhs.sortOrder
        })

        self.items = items.sorted(by: { (lhs: ContentItem, rhs: ContentItem) -> Bool in
            return lhs.sortOrder > rhs.sortOrder
        })
    }
}
