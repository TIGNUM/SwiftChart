//
//  DailyBriefWorker.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DailyBriefWorker {

    // MARK: - Properties

    private let services: Services?

    // MARK: - Init

    init(services: Services?) {
        self.services = services
    }

    private lazy var firstInstallTimeStamp: Date? = {
        return UserDefault.firstInstallationTimestamp.object as? Date
    }()

    lazy var strategies: [Knowing.StrategyItem] = {
        guard let strategies = services?.contentService.learnContentCategories() else { return [] }
        var strategyItems: [Knowing.StrategyItem] = []
        for strategy in strategies {
            let viewedCount = strategy.viewedCount(section: .learnStrategy)
            let itemCount = strategy.itemCount(section: .learnStrategy)
            strategyItems.append(Knowing.StrategyItem(title: strategy.title,
                                                      remoteID: strategy.remoteID.value ?? 0,
                                                      viewedCount: viewedCount,
                                                      itemCount: itemCount,
                                                      sortOrder: strategy.sortOrder))
        }
        return strategyItems.sorted(by: { (lhs, rhs) -> Bool in
            lhs.sortOrder < rhs.sortOrder
        })
    }()

    lazy var whatsHotItems: [Knowing.WhatsHotItem] = {
        guard let whatsHotArticles = services?.contentService.whatsHotArticles() else { return [] }
        var whatsHotItems: [Knowing.WhatsHotItem] = []
        for article in whatsHotArticles {
            if
                let collectionId = article.remoteID.value,
                let body = services?.contentService.contentItems(contentCollectionID: collectionId).first?.valueText {
                whatsHotItems.append(Knowing.WhatsHotItem(title: article.title,
                                                          body: body,
                                                          image: article.thumbnailURL,
                                                          remoteID: collectionId,
                                                          author: article.author ?? "",
                                                          publishDate: article.publishDate,
                                                          timeToRead: article.durationString,
                                                          isNew: isNew(article)))
            }
        }
        return whatsHotItems
    }()

    func contentList(selectedStrategyID: Int) -> [ContentCollection] {
        guard let contentList = services?.contentService.contentCategory(id: selectedStrategyID)?.contentCollections else { return [] }
        return Array(contentList)
    }
}

private extension DailyBriefWorker {
    func isNew(_ article: ContentCollection) -> Bool {
        var isNewArticle = article.contentRead == nil
        if let firstInstallTimeStamp = self.firstInstallTimeStamp {
            isNewArticle = article.contentRead == nil && article.modifiedAt > firstInstallTimeStamp
        }
        return isNewArticle
    }
}
