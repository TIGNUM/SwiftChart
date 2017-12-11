//
//  ArticleCollectionProvider.swift
//  QOT
//
//  Created by Lee Arromba on 28/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

class ArticleCollectionProvider {
    private let services: Services
    private let contentCollections: AnyRealmCollection<ContentCollection>
    private let syncStateObserver: SyncStateObserver
    private var notificationTokenHandler: NotificationTokenHandler?
    private var tokenBin = TokenBin()
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMdd")
        dateFormatter.locale = .current
        return dateFormatter
    }()
    var updateBlock: ((ArticleCollectionViewData) -> Void)?

    init(services: Services) {
        self.services = services
        contentCollections = services.contentService.whatsHotArticles()
        syncStateObserver = SyncStateObserver(realm: services.mainRealm)
        notificationTokenHandler = contentCollections.addNotificationBlock { [unowned self] change in
            self.updateBlock?(self.provideViewData())
        }.handler
        syncStateObserver.observe(\.syncedClasses, options: [.new]) { [unowned self] _, _ in
            self.updateBlock?(self.provideViewData())
        }.addTo(tokenBin)
    }

    func provideViewData() -> ArticleCollectionViewData {
        let items = Array(contentCollections).flatMap { contentCollection -> ArticleCollectionViewData.Item? in
            guard contentCollection.articleItems.count > 0 else {
                return nil
            }
            return ArticleCollectionViewData.Item(
                title: contentCollection.contentCategories.first?.title ?? "",
                description: contentCollection.title,
                date: DateFormatter.shortDate.string(from: contentCollection.createdAt),
                duration: "\(contentCollection.items.reduce(0) { $0 + $1.secondsRequired } / 60) MIN", //TODO Localise?
                articleDate: dateFormatter.string(from: contentCollection.editedAt),
                sortOrder: String(format: "#%002d", contentCollection.sortOrder), //TODO Localise?
                previewImageURL: contentCollection.thumbnailURL,
                contentCollectionID: contentCollection.remoteID.value ?? 0
            )
        }
        return ArticleCollectionViewData(items: items)
    }
}
