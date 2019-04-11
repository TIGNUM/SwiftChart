//
//  KnowingWorker.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class KnowingWorker {

    // MARK: - Properties

    private let services: Services?
    private lazy var firstInstallTimeStamp: Date? = {
        return UserDefault.firstInstallationTimestamp.object as? Date
    }()

    // MARK: - Init

    init(services: Services?) {
        self.services = services
    }

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

    lazy var foundationStrategy: Knowing.StrategyItem? = {
        return strategies.filter { $0.title.contains("Foundation") }.first
    }()

    lazy var fityFiveStrategies: [Knowing.StrategyItem] = {
        guard let foundation = foundationStrategy else { return [] }
        return strategies.filter { $0 != foundation }
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

    func header(for section: Knowing.Section) -> (title: String?, subtitle: String?) {
        let title = services?.contentService.contentItem(for: section.titlePredicate)?.valueText
        let subtitle = services?.contentService.contentItem(for: section.subtitlePredicate)?.valueText
        return (title: title, subtitle: subtitle)
    }
}

// MARK: - Private

private extension KnowingWorker {
    func isNew(_ article: ContentCollection) -> Bool {
        var isNewArticle = article.contentRead == nil
        if let firstInstallTimeStamp = self.firstInstallTimeStamp {
            isNewArticle = article.contentRead == nil && article.modifiedAt > firstInstallTimeStamp
        }
        return isNewArticle
    }
}
