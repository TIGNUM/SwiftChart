//
//  ArticleCollectionProvider.swift
//  QOT
//
//  Created by Lee Arromba on 28/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class ArticleCollectionProvider {
    private let services: Services
    private let contentCollections: AnyRealmCollection<ContentCollection>
    private let syncStateObserver: SyncStateObserver
    private var notificationTokenHandler: NotificationTokenHandler?
    private var tokenBin = TokenBin()
    var updateBlock: ((ArticleCollectionViewData) -> Void)?

    init(services: Services) {
        self.services = services
        contentCollections = services.contentService.whatsHotArticles()
        syncStateObserver = SyncStateObserver(realm: services.mainRealm)
        notificationTokenHandler = contentCollections.observe { [unowned self] change in
            self.updateBlock?(self.provideViewData())
        }.handler
        syncStateObserver.onUpdate { [unowned self] _ in
            self.updateBlock?(self.provideViewData())
        }
    }

    func provideViewData() -> ArticleCollectionViewData {
        let items = Array(contentCollections).compactMap { content -> ArticleCollectionViewData.Item? in
            guard content.articleItems.count > 0 else { return nil }
            var authorValue = ""
            if let author = content.author, author.isEmpty == false {
                authorValue = R.string.localized.aricleAuthorBy(author)
            }

            var isNewArticle = content.contentRead == nil
            if let firstInstallTimeStamp = UserDefault.firstInstallationTimestamp.object as? Date {
                isNewArticle = content.contentRead == nil && content.modifiedAt > firstInstallTimeStamp
            }

            return ArticleCollectionViewData.Item(
                author: authorValue,
                title: content.contentCategories.first?.title ?? "",
                description: content.title,
                date: content.createdAt,
                duration: "\(content.items.reduce(0) { $0 + $1.secondsRequired } / 60) MIN", //TODO Localise?
                articleDate: content.publishDate ?? content.createdAt,
                sortOrder: String(format: "#%002d", content.sortOrder), //TODO Localise?
                previewImageURL: content.thumbnailURL,
                contentCollectionID: content.remoteID.value ?? 0,
                newArticle: isNewArticle,
                shareableLink: content.shareableLink)
        }
        let articleCollectionViewData = ArticleCollectionViewData(items: items)
        ExtensionUserDefaults.set(articleCollectionViewData, for: .whatsHot)
        return articleCollectionViewData
    }
}
