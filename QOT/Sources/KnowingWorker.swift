//
//  KnowingWorker.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal
final class KnowingWorker {

    // MARK: - Properties
    weak var interactor: KnowingInteractorInterface?
    private let services: Services?
    private lazy var firstInstallTimeStamp: Date? = {
        return UserDefault.firstInstallationTimestamp.object as? Date
    }()

    // MARK: - Init

    init(services: Services?) {
        self.services = services
    }

    func loadData() {
        qot_dal.ContentService.main.getContentCategories(StrategyContentCategories) { (categories) in
            var strategyItems: [Knowing.StrategyItem] = []
            for strategy in categories ?? [] {
                let items = strategy.contentCollections.filter({ (content) -> Bool in
                    content.section == .LearnStrategies
                })
                let itemCount = items.count
                let viewedCount = items.filter({ (content) -> Bool in
                    content.viewedAt != nil
                }).count

                strategyItems.append(Knowing.StrategyItem(title: strategy.title,
                                                          remoteID: strategy.remoteID ?? 0,
                                                          viewedCount: viewedCount,
                                                          itemCount: itemCount,
                                                          sortOrder: strategy.sortOrder))
            }
            self.strategies = strategyItems.sorted(by: { (lhs, rhs) -> Bool in
                lhs.sortOrder < rhs.sortOrder
            })
        }

        qot_dal.ContentService.main.getContentCategory(.WhatsHot) { (category) in
            guard let category = category else {
                self.interactor?.reload()
                return
            }
            var whatsHotItems: [Knowing.WhatsHotItem] = []
            for article in category.contentCollections.filter({ $0.section == .WhatsHot }) {
                if let collectionId = article.remoteID {
                    whatsHotItems.append(Knowing.WhatsHotItem(title: article.title,
                                                              body: article.contentItems.first?.valueText ?? "",
                                                              image: URL(string: article.thumbnailURLString ?? ""),
                                                              remoteID: collectionId,
                                                              author: article.author ?? "",
                                                              publishDate: article.publishedDate ?? article.modifiedAt,
                                                              timeToRead: article.durationString,
                                                              isNew: self.isNew(article)))
                }
            }
            self.whatsHotItems = whatsHotItems.sorted(by: { (first, second) -> Bool in
                first.publishDate ?? Date() > second.publishDate ?? Date()
            })
            self.interactor?.reload()
        }
    }

    var strategies = [Knowing.StrategyItem]()

    var foundationStrategy: Knowing.StrategyItem? {
        return strategies.filter { $0.title.contains("Foundation") }.first
    }

    var fityFiveStrategies: [Knowing.StrategyItem] {
        guard let foundation = foundationStrategy else { return [] }
        return strategies.filter { $0 != foundation }
    }

    var whatsHotItems = [Knowing.WhatsHotItem]()

    func header(for section: Knowing.Section) -> (title: String?, subtitle: String?) {
        let title = services?.contentService.contentItem(for: section.titlePredicate)?.valueText
        let subtitle = services?.contentService.contentItem(for: section.subtitlePredicate)?.valueText
        return (title: title, subtitle: subtitle)
    }
}

// MARK: - Private

private extension KnowingWorker {
    func isNew(_ article: QDMContentCollection) -> Bool {
        var isNewArticle = article.viewedAt == nil
        if let firstInstallTimeStamp = self.firstInstallTimeStamp {
            isNewArticle = article.viewedAt == nil && article.modifiedAt ?? article.createdAt ?? Date() > firstInstallTimeStamp
        }
        return isNewArticle
    }
}
