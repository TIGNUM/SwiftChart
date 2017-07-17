//
//  LearnCategoriesViewModel.swift
//  QOT
//
//  Created by Sam Wyndham on 08/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import RealmSwift

final class LearnCategoryListViewModel {

    struct Item {
        let title: String
        let viewedCount: Int
        let itemCount: Int
        let percentageLearned: Double

        init(category: ContentCategory) {
            title = category.title
            viewedCount = category.viewedCount
            itemCount = category.itemCount
            percentageLearned = category.percentageLearned
        }
    }

    private let categories: AnyRealmCollection<ContentCategory>
    private var token: NotificationToken? // FIXME: NotificationTokenHandler

    let updates = PublishSubject<CollectionUpdate, NoError>()

    init(service: ContentService, realmObserver: RealmObserver) {
        self.categories = service.learnContentCategories()

        token = categories.addNotificationBlock { [unowned self] (change) in
            self.updates.next(change.update(section: 0))
        }
    }

    var itemCount: Index {
        return categories.count
    }

    func item(at index: Index) -> Item {
        return Item(category: categories[index])
    }
}
