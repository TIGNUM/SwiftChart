//
//  ChatViewModel.swift
//  QOT
//
//  Created by karmic on 23/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

protocol ChatChoice {
    var title: String { get }
}

struct ChatItem<T: ChatChoice> {

    enum ChatItemType<T: ChatChoice> {
        case message(String)
        case choiceList([T])
    }

    let identifier = UUID().uuidString
    let type: ChatItemType<T>
    let alignment: ChatViewAlignment
    let timestamp: Date
    let header: String?
    let footer: String?
    let isAutoscrollSnapable: Bool

    init(type: ChatItemType<T>,
         alignment: ChatViewAlignment,
         timestamp: Date,
         header: String? = nil,
         footer: String? = nil,
         isAutoscrollSnapable: Bool = false) {
        self.type = type
        self.alignment = alignment
        self.timestamp = timestamp
        self.header = header?.nilled
        self.footer = footer?.nilled
        self.isAutoscrollSnapable = isAutoscrollSnapable
    }

    var isMessage: Bool {
        guard case ChatItemType<T>.message(_) = self.type else {
            return false
        }
        return true
    }
}

final class ChatViewModel<T: ChatChoice> {

    enum Update {
        case reload(items: [ChatItem<T>])
        case update(items: [ChatItem<T>], deletions: [Index], insertions: [Index], modifications: [Index])
    }

    private var items: [ChatItem<T>]
    private var queue: ChatItemQueue<T>?
    private var selected: [String: Int] = [:]

    let updates = PublishSubject<Update, NoError>()

    init(items: [ChatItem<T>]) {
        self.items = items
        setupQueue()
    }

    func didSelectItem(at indexPath: IndexPath) {
        let item = items[indexPath.section]
        switch item.type {
        case .choiceList:
            selected[item.identifier] = indexPath.item
        default:
            assertionFailure("This is not a choiceList")
        }
    }

    func isSelectedItem(at indexPath: IndexPath) -> Bool {
        let item = items[indexPath.section]
        return selected[item.identifier] == indexPath.item
    }

    func canSelectItem(at indexPath: IndexPath) -> Bool {
        let item = items[indexPath.section]
        switch item.type {
        case .choiceList:
            return selected[item.identifier] == nil
        default:
            return false
        }
    }

    func setItems(_ newItems: [ChatItem<T>]) {
        queue?.invalidate()
        items = newItems
        updates.next(.reload(items: newItems))
        setupQueue()
    }

    func appendItems(_ items: [ChatItem<T>]) {
        for item in items {
            queue?.push(item)
        }
    }

    private func setupQueue() {
        queue = ChatItemQueue<T>(popHandler: { [weak self] (item) in
            guard let `self` = self else {
                return
            }

            self.items.append(item)
            let index = self.items.count - 1
            self.updates.next(.update(items: self.items, deletions: [], insertions: [index], modifications: []))
        })
    }
}
