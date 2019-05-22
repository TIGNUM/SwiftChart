//
//  ArticleItemViewModel.swift
//  QOT
//
//  Created by karmic on 22.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class ArticleItemViewModel {

    // MARK: - Properties

    private let items: [ContentItem]
    private let relatedArticles: [ContentCollection]
    private let services: Services
    let backgroundImage: UIImage?
    let articleHeader: ArticleCollectionHeader?
    let contentCollection: ContentCollection

    var isWhatsHot: Bool {
        return contentCollection.section.caseInsensitiveCompare(Database.Section.learnWhatsHot.value) == .orderedSame
    }

    var sectionCount: Int {
        return relatedArticles.count > 0 ? 2 : 1
    }

    // MARK: - Init

    init(services: Services,
         items: [ContentItem],
         contentCollection: ContentCollection,
         articleHeader: ArticleCollectionHeader?,
         backgroundImage: UIImage? = nil) {
        self.services = services
        self.articleHeader = articleHeader
        self.backgroundImage = backgroundImage
        self.contentCollection = contentCollection
        let relatedArticles = services.contentService.relatedArticles(for: contentCollection)

        self.relatedArticles = relatedArticles.sorted { (lhs: ContentCollection, rhs: ContentCollection) -> Bool in
            return lhs.sortOrder < rhs.sortOrder
        }

        self.items = items.sorted { (lhs: ContentItem, rhs: ContentItem) -> Bool in
            return lhs.sortOrder > rhs.sortOrder
        }
    }
}

// MARK: - Public

extension ArticleItemViewModel {

    func articleItemVideo(for mediaURL: URL?) -> ContentItem? {
        let audioItem = services.contentService.contentItemsAudio().filter { $0.valueMediaURL ?? "" == mediaURL?.absoluteString ?? "" }.first
        let videoItem = services.contentService.contentItemsVideo().filter { $0.valueMediaURL ?? "" == mediaURL?.absoluteString ?? "" }.first
        return audioItem ?? videoItem
    }

    func markContentAsRead() {
        services.contentService.setContentCollectionViewed(localID: contentCollection.localID)
    }

    func articleItem(at indexPath: IndexPath) -> ContentItem {
        return items[indexPath.row]
    }

    func relatedArticle(at indexPath: IndexPath) -> ContentCollection {
        return relatedArticles[indexPath.row]
    }

    func itemCount(in section: Index) -> Int {
        switch section {
        case 0: return items.count
        case 1: return relatedArticles.count > 3 ? 3 : relatedArticles.count
        default: return 0
        }
    }
}
