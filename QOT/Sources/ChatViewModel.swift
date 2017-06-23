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

    init(type: ChatItemType, delay: TimeInterval = 2) {
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

struct PrepareChatChoice: ChatChoice {
    let id: Int
    let title: String
}

func mockPrepareChatItems() -> [ChatItem<PrepareChatChoice>] {
    let choices1 = [PrepareChatChoice(id: 0, title: "i want to prepare for an event"),
                    PrepareChatChoice(id: 1, title: "i want to check in with my normal $ tough day protocols"),
                    PrepareChatChoice(id: 2, title: "i struggle and i am looking for some solutions")]
    let choices2 = [PrepareChatChoice(id: 3, title: "Meeting"),
                    PrepareChatChoice(id: 4, title: "Negotiation"),
                    PrepareChatChoice(id: 5, title: "Presentation"),
                    PrepareChatChoice(id: 6, title: "Business dinner"),
                    PrepareChatChoice(id: 7, title: "Pre-vacation"),
                    PrepareChatChoice(id: 8, title: "High performance travel"),
                    PrepareChatChoice(id: 9, title: "Work to home transition")]

    var items: [ChatItem<PrepareChatChoice>] = []
    items.append(ChatItem(type: .message("Hi Louis\nWhat are you preparing for?")))
    items.append(ChatItem(type: .footer("Delivered at 12:58", alignment: .left)))
    items.append(ChatItem(type: .choiceList(choices1, display: .list)))
    items.append(ChatItem(type: .footer("Delivered at 12:58", alignment: .right)))
    items.append(ChatItem(type: .message("Here what you need")))
    items.append(ChatItem(type: .footer("Delivered at 12:58", alignment: .left)))
    items.append(ChatItem(type: .footer("PREPARATIONS", alignment: .left)))
    items.append(ChatItem(type: .choiceList(choices2, display: .flow)))
    items.append(ChatItem(type: .message("Your preparation for **Trip to Basel on 21st April 2017** has been saved in the calendar")))

    return items
}
