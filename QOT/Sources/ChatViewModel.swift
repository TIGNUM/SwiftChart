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

struct ChatItem<T: ChatChoice>: Equatable {

    enum ChatItemType<T: ChatChoice> {
        case message(String)
        case choiceList([T])
    }

    enum ChatType {
        case onBoarding
        case prepare
        case visionGenerator
    }

    struct Footer {
        static func delivered(_ includeFooter: Bool) -> String? {
            guard includeFooter == true else { return nil }
            let time = DateFormatter.displayTime.string(from: Date())
            return R.string.localized.prepareChatFooterDeliveredTime(time)
        }
    }

    let identifier = UUID().uuidString
    let type: ChatItemType<T>
    let chatType: ChatType
    let alignment: ChatViewAlignment
    let timestamp: Date
    let header: String?
    let footer: String?
    let isAutoscrollSnapable: Bool
    let allowsMultipleSelection: Bool

    init(type: ChatItemType<T>,
         chatType: ChatType,
         alignment: ChatViewAlignment,
         timestamp: Date,
         header: String? = nil,
         showFooter: Bool,
         isAutoscrollSnapable: Bool = false,
         allowsMultipleSelection: Bool = false) {
        self.type = type
        self.chatType = chatType
        self.alignment = alignment
        self.timestamp = timestamp
        self.header = header?.nilled
        self.footer = Footer.delivered(showFooter)
        self.isAutoscrollSnapable = isAutoscrollSnapable
        self.allowsMultipleSelection = allowsMultipleSelection
    }

    var isMessage: Bool {
        guard case ChatItemType<T>.message(_) = self.type else { return false }
        return true
    }

    static func == (lhs: ChatItem<T>, rhs: ChatItem<T>) -> Bool {
        return lhs == rhs
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
    private var selectedVisionChoices = [String]()
    var visionGeneratorInteractor: VisionGeneratorInteractorInterface?

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

    func selectOrDeSelectItem(at indexPath: IndexPath) {
        let item = items[indexPath.section]
        switch item.type {
        case .choiceList(let choices):
            let choice = choices[indexPath.item]
            if selectedVisionChoices.contains(choice.title + item.identifier) == true {
                selectedVisionChoices.remove(object: choice.title + item.identifier)
            } else {
                selectedVisionChoices.append(choice.title + item.identifier)
            }
        default:
            assertionFailure("This is not a choiceList")
        }
    }

    func isSelectedItem(at indexPath: IndexPath) -> Bool {
        let item = items[indexPath.section]
        if item.chatType != .visionGenerator {
            return selected[item.identifier] == indexPath.item
        } else {
            switch item.type {
            case .choiceList(let choices):
                let choice = choices[indexPath.item]
                return selectedVisionChoices.contains(choice.title  + item.identifier)
            default: return false
            }
        }
    }

    func canSelectItem(at indexPath: IndexPath) -> Bool {
        let item = items[indexPath.section]
        switch item.type {
        case .choiceList(let choices) where item.allowsMultipleSelection:
            if item.chatType != .visionGenerator {
                return true
            }
            guard let selectionCount = visionGeneratorInteractor?.visionSelectionCount else { return true }
            let choice = choices[indexPath.item]
            return selectionCount < 4 || selectedVisionChoices.contains(choice.title  + item.identifier)
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

    func updateItems(oldItems: [ChatItem<T>], newItems: [ChatItem<T>]) {
        items = items.filter { oldItems.contains(obj: $0) == false }
        items.append(contentsOf: newItems)
        updates.next(.reload(items: items))
    }

    private func setupQueue() {
        queue = ChatItemQueue<T>(popHandler: { [weak self] (item) in
            guard let `self` = self else { return }
            self.items.append(item)
            let index = self.items.count - 1
            self.updates.next(.update(items: self.items, deletions: [], insertions: [index], modifications: []))
        })
    }
}

extension Array {
    func contains<T>(obj: T) -> Bool where T: Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}
