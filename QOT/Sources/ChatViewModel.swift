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
    enum ChatItemState {
        case typing
        case display
    }
    enum ChatItemType {
        case message(String)
        case choiceList([T], display: ChoiceListDisplay)
        case header(String, alignment: NSTextAlignment)
        case footer(String, alignment: NSTextAlignment)
    }

    let type: ChatItemType
    var state: ChatItemState
    let delay: TimeInterval
    let identifier = UUID().uuidString

    init(type: ChatItemType, state: ChatItemState = .display, delay: TimeInterval = 0.2) {
        self.type = type
        self.state = state
        self.delay = delay
    }
}

enum ChoiceListDisplay {
    case flow
    case list
}

protocol ChatViewModelDelegate: class {
    func canChatStart() -> Bool
}

enum ChatCollectionUpdate {
    case willBegin
    case didFinish
    case reload
    case update(deletions: [IndexPath], insertions: [IndexPath], modifications: [IndexPath])
}

final class ChatViewModel<T: ChatChoice> {

    private var queue: [ChatItem<T>] = []
    private var items: [ChatItem<T>] = []
    private var selected: [String: Int] = [:]
    private var timer: Timer?
    weak var delegate: ChatViewModelDelegate?
    
    let updates = PublishSubject<ChatCollectionUpdate, NoError>()

    init(items: [ChatItem<T>] = []) {
        set(items: items)
    }
    
    func start() {
        guard timer == nil, let delegate = delegate, delegate.canChatStart(), queue.count > 0 else {
            return
        }
        updates.next(.willBegin)
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.timerTick(_:)), userInfo: nil, repeats: false)
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    func select(itemIndex: Int, choiceIndex: Int) {
        let item = items[itemIndex]
        switch item.type {
        case .choiceList:
            selected[item.identifier] = choiceIndex
        default:
            assertionFailure("This is not a choiceList")
        }
    }

    func isSelected(itemIndex: Int, choiceIndex: Int) -> Bool {
        let item = items[itemIndex]
        return selected[item.identifier] == choiceIndex
    }

    func canSelectItem(index: Index) -> Bool {
        let item = items[index]
        switch item.type {
        case .choiceList:
            return selected[item.identifier] == nil
        default:
            return false
        }
    }
    
    func setItem(_ item: ChatItem<T>, at index: Index) {
        items[index] = item
    }

    func set(items: [ChatItem<T>]) {
        self.items = []
        selected = [:]
        queue = items
        updates.next(.reload)
        start()
    }

    func append(items: [ChatItem<T>]) {
        queue.append(contentsOf: items)
        start()
    }

    var itemCount: Index {
        return items.count
    }

    func item(at index: Index) -> ChatItem<T> {
        return items[index]
    }
    
    // MARK: - private
    
    private func popQueue() -> ChatItem<T>? {
        guard let item = queue.first else {
            return nil
        }
        queue.remove(at: 0)
        return item
    }
    
    @objc private func timerTick(_ sender: Timer) {
        // pop the queue
        guard let item = popQueue() else {
            updates.next(.didFinish)
            stop()
            return
        }
        
        // restart the timer
        restart(withTimeInterval: item.delay)

        // insert new row
        let row = items.count
        let insertions = [IndexPath(row: row, section: 0)]
        var modifications = [IndexPath]()
        
        // stop typing previous row
        if row > 0 {
            let previousRow = row - 1
            var previousItem = items[previousRow]
            if previousItem.state == .typing {
                previousItem.state = .display
                setItem(previousItem, at: previousRow)
                modifications.append(IndexPath(row: previousRow, section: 0))
            }
        }
        
        // update
        items.append(item)
        let update = ChatCollectionUpdate.update(deletions: [], insertions: insertions, modifications: modifications)
        updates.next(update)
    }
    
    private func restart(withTimeInterval timeInterval: TimeInterval) {
        stop()
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerTick(_:)), userInfo: nil, repeats: false)
    }
}
