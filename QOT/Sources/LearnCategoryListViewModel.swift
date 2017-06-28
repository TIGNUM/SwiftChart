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

    struct Item: Equatable {
        let title: String
        let viewedCount: Int
        let itemCount: Int
        let percentageLearned: Double

        init(category: ContentCategory) {
            self.title = category.title
            self.viewedCount = category.viewedCount
            self.itemCount = category.itemCount
            self.percentageLearned = category.percentageLearned
        }

        public static func == (lhs: Item, rhs: Item) -> Bool {
            return lhs.title == rhs.title
                && lhs.viewedCount == rhs.viewedCount
                && lhs.itemCount == rhs.itemCount
                && lhs.percentageLearned == rhs.percentageLearned
        }
    }

    private let service: ContentService
    private let realmObserver: RealmObserver
    private let queue = DispatchQueue(label: "LearnCategoryListViewModel.queue")
    private var items: [Item] = [] {
        didSet { updates.next(.reload) }
    }

    let updates = PublishSubject<CollectionUpdate, NoError>()

    var categoryCount: Index {
        return items.count
    }

    // MARK: - Init

    init(service: ContentService, realmObserver: RealmObserver) {
        self.service = service
        self.realmObserver = realmObserver

        updateItems()
        realmObserver.handler = { [weak self] in
            self?.updateItems()
        }
    }

    func category(at index: Index) -> Item {
        return items[index]
    }

    private func updateItems() {
        queue.async { [weak self] in
            do {
                if let categories = try self?.service.learnContentCategoriesOnBackground(), let existing = self?.items {
                    let new = Array(categories).map { Item(category: $0) }
                    if new != existing {
                        DispatchQueue.main.async {
                            self?.items = new
                        }
                    }
                }
            } catch let error {
                print("Failed to update category list: \(error)")
            }
        }
    }
}
