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

    enum ChatItemType {
        case message(String)
        case choiceList([T], display: ChoiceListDisplay)
        case header(String, alignment: NSTextAlignment)
        case footer(String, alignment: NSTextAlignment)
    }

    let type: ChatItemType
    let delay: TimeInterval

    init(type: ChatItemType, delay: TimeInterval = 0.2) {
        self.type = type
        self.delay = delay
    }
}

enum ChoiceListDisplay {
    case flow
    case list
}

final class ChatViewModel<T: ChatChoice> {

    private let operationQueue = OperationQueue()
    private var items: [ChatItem<T>] = []

    let updates = PublishSubject<CollectionUpdate, NoError>()

    init(items: [ChatItem<T>] = []) {
        operationQueue.maxConcurrentOperationCount = 1
        append(items: items)
    }

    func setItems(items: [ChatItem<T>]) {
        operationQueue.addOperation { [weak self] in
            DispatchQueue.main.async {
                self?.items = items
                self?.updates.next(.reload)
            }
        }
    }

    func append(items: [ChatItem<T>]) {
        for item in items {
            operationQueue.addOperation { [weak self] in
                let delay = item.delay * 1000000
                usleep(useconds_t(delay))
                DispatchQueue.main.async {
                    guard let strongSelf = self else {
                        return
                    }

                    let indexPath = IndexPath(item: strongSelf.items.count, section: 0)
                    let update = CollectionUpdate.update(deletions: [], insertions: [indexPath], modifications: [])
                    strongSelf.items.append(item)
                    strongSelf.updates.next(update)
                }
            }
        }
    }

    var itemCount: Index {
        return items.count
    }

    func item(at index: Index) -> ChatItem<T> {
        return items[index]
    }
}
