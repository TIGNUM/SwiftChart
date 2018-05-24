//
//  LearnContentCollectionViewModel.swift
//  QOT
//
//  Created by Sam Wyndham on 09/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import RealmSwift

enum LearnContentTitle: String {

    case mindset = "PERFORMANCE MINDSET"
    case nutrition = "PERFORMANCE NUTRITION"
    case movement = "PERFORMANCE MOVEMENT"
    case recovery = "PERFORMANCE RECOVERY"
    case habituation = "PERFORMANCE HABITUATION"
    case foundation = "PERFORMANCE FOUNDATION"

    static let allTitles = [mindset, nutrition, movement, recovery, habituation, foundation]
}

/// The view model of a `LearnContentListViewController`.
final class LearnContentCollectionViewModel {

    // MARK: - Properties

    private let categories: AnyRealmCollection<ContentCategory>
    private var token: NotificationTokenHandler?
    let updates = PublishSubject<CollectionUpdate, NoError>()

    // MARK: - Init

    init(services: Services, selectedIndex: Index) {
        self.categories = services.contentService.learnContentCategories()
        token = categories.addNotificationBlock { [unowned self] (_) in
            self.updates.next(.reload)
        }.handler
    }

    var categoryCount: Int {
        return categories.count
    }

    func category(at index: Index) -> ContentCategory {
        return categories[index]
    }

    func itemCount(categoryIndex: Index) -> Int {
        return category(at: categoryIndex).learnContent.count
    }

    func item(at indexPath: IndexPath, categorySelectedIndex: Int) -> ContentCollection {
        return categories[categorySelectedIndex].learnContent[indexPath.row]
    }

    func navigationTitle(for index: Index) -> String {
        return LearnContentTitle.allTitles[index].rawValue
    }
}
