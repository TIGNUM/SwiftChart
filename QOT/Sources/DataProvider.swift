//
//  DataProvider.swift
//  QOT
//
//  Created by Sam Wyndham on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveKit

enum DataProviderChange {
    case initial
    case update(deletions: [Int], insertions: [Int], modifications: [Int])
}

final class DataProvider<Element> {
    private var token: NotificationToken?
    private let _changes = PublishSubject<DataProviderChange, NoError>()
    private let _count: () -> Int
    private let _itemAt: (Int) -> Element
    private let _items: () -> [Element]

    init<T: Object>(items: Results<T>, map: @escaping (T) -> Element ) {
        self._count = { items.count }
        self._itemAt = { (index) in
            return map(items[index])
        }
        self._items = { items.map(map) }
        self.token = items.addNotificationBlock(notificationBlock())
    }

    init<T: Object>(items: List<T>, map: @escaping (T) -> Element ) {
        self._count = { items.count }
        self._itemAt = { (index) in
            return map(items[index])
        }
        self._items = { items.map(map) }
        self.token = items.addNotificationBlock(notificationBlock())
    }

    init<T: Object>(items: LinkingObjects<T>, map: @escaping (T) -> Element ) {
        self._count = { items.count }
        self._itemAt = { (index) in
            return map(items[index])
        }
        self._items = { items.map(map) }
        self.token = items.addNotificationBlock(notificationBlock())
    }

    var count: Int {
        return _count()
    }

    // FIXME: Currently this is an expensive operation. It should be made to act lazily.
    var items: [Element] {
        return _items()
    }

    func item(at index: Index) -> Element {
        return _itemAt(index)
    }

    func observeChange(with observer: @escaping (DataProviderChange) -> Void) -> Disposable {
        return _changes.observeNext(with: observer)
    }

    private func notificationBlock<T>() -> (RealmCollectionChange<T>) -> Void {
        return { [unowned self] (change) in
            switch change {
            case .initial:
                self._changes.next(.initial)
            case .update(_, let deletions, let insertions, let modifications):
                self._changes.next(.update(deletions: deletions, insertions: insertions, modifications: modifications))
            case .error(let error):
                assertionFailure("Realm results errored: \(error)")
            }
        }
    }
}
