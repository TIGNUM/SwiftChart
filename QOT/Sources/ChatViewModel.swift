//
//  ChatViewModel.swift
//  QOT
//
//  Created by karmic on 23/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class ChatViewModel {

    // MARK: - Properties

    fileprivate var chatMessages = [ChatMessage]()
    fileprivate let prepareContentCategory: PrepareContentCategory
    fileprivate var timer: Timer?
    let updates = PublishSubject<CollectionUpdate, NoError>()

    fileprivate lazy var mockChatMessages: [ChatMessage] = {
        return mockChatMessage(prepareContentCategory: self.prepareContentCategory)
    }()

    init(prepareContentCategory: PrepareContentCategory) {
        self.prepareContentCategory = prepareContentCategory
        setupTimer()
    }

    var itemCount: Index {
        return chatMessages.count
    }

    func item(at row: Index) -> ChatMessage {
        return chatMessages[row]
    }

    deinit {
        timer?.invalidate()
    }
}

// MARK: - MOCK

extension ChatViewModel {

    fileprivate func setupTimer() {
        let timer = Timer.init(fire: Date(timeIntervalSinceNow: 1), interval: 2, repeats: true) { [unowned self] (timer) in
            if let first = self.mockChatMessages.first {
                let index = self.chatMessages.count
                self.mockChatMessages.remove(at: 0)
                self.chatMessages.append(first)
                let update = CollectionUpdate.update(deletions: [], insertions: [IndexPath(item: index, section: 0)], modifications: [])
                self.updates.next(update)
            } else {
                self.timer?.invalidate()
            }
        }

        RunLoop.main.add(timer, forMode: .defaultRunLoopMode)
    }
}

enum ChatMessage {
    case instruction(type: InstructionType, showIcon: Bool)
    case header(title: String, alignment: NSTextAlignment)
    case navigation(PrepareContentCategory)
    case input([ChatMessageInput])

    enum InstructionType {
        case message(String)
        case typing
    }
}

protocol ChatMessageInput {
    var localID: String { get }
    var title: String { get }
    var selected: Bool { get }
}

private struct MockChatMessageInput: ChatMessageInput {
    let localID = UUID().uuidString
    let title: String
    let selected: Bool
}

private var chatMessageInputs: [ChatMessageInput] {
    return [
        MockChatMessageInput(title: "Normal day", selected: false),
        MockChatMessageInput(title: "Tough day", selected: false)
    ]
}

private func mockChatMessage(prepareContentCategory: PrepareContentCategory) -> [ChatMessage] {
    let instructionTypeMessage = ChatMessage.InstructionType.message("Hi Louis what are you preparing for?")
    let instruction = ChatMessage.instruction(type: instructionTypeMessage, showIcon: true)
    let header = ChatMessage.header(title: "Delivered: 12:34", alignment: .left)
    let navigations = ChatMessage.navigation(prepareContentCategory)
    let inputs = ChatMessage.input(chatMessageInputs)

    return [instruction, header, navigations, inputs]
}
