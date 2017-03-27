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

    fileprivate var mockChatMessages: [ChatMessage] = mockChatMessage
    fileprivate var chatMessages = [ChatMessage]()
    fileprivate var timer: Timer?
    let updates = PublishSubject<CollectionUpdate, NoError>()

    init() {
        setupTimer()
    }

    var chatMessageCount: Index {
        return chatMessages.count
    }

    func chatMessage(at row: Index) -> ChatMessage {
        return chatMessages[row]
    }

    deinit {
        timer?.invalidate()
    }
}

// MARK - MOCK

extension ChatViewModel {

    fileprivate func setupTimer() {
        let timer = Timer.init(fire: Date(timeIntervalSinceNow: 1), interval: 2, repeats: true) { [unowned self] (timer) in
            if let first = self.mockChatMessages.first {
                let index = self.chatMessages.count
                self.mockChatMessages.remove(at: 0)
                self.chatMessages.append(first)
                let update = CollectionUpdate.update(deletions: [], insertions: [index], modifications: [])
                self.updates.next(update)
            } else {
                self.timer?.invalidate()
            }
        }

        RunLoop.main.add(timer, forMode: .defaultRunLoopMode)
    }
}

enum ChatMessage {
    case instruction(type: InstructionType, image: UIImage?)
    case header(title: String, alignment: NSTextAlignment)
    case navigation([ChatMessageNavigation])
    case input([ChatMessageInput])

    enum InstructionType {
        case message(String)
        case typing
    }
}

struct ChatMessageNavigation {
    let title: String
    let selected: Bool
}

struct ChatMessageInput {
    let title: String
    let selected: Bool
}

private var chatMessageNavigations: [ChatMessageNavigation] {
    return [
        ChatMessageNavigation(title: "Meeting", selected: false),
        ChatMessageNavigation(title: "Negotiation", selected: false),
        ChatMessageNavigation(title: "Presentation", selected: false),
        ChatMessageNavigation(title: "Business Dinner", selected: false),
        ChatMessageNavigation(title: "Pre-Vacation", selected: false),
        ChatMessageNavigation(title: "Work to home transition", selected: false)
    ]
}

private var chatMessageInputs: [ChatMessageInput] {
    return [
        ChatMessageInput(title: "Normal day", selected: false),
        ChatMessageInput(title: "Tough day", selected: false)
    ]
}

private var mockChatMessage: [ChatMessage] {
    let instructionTypeMessage = ChatMessage.InstructionType.message("Hi Louis what are you preparing for?")
    let instruction = ChatMessage.instruction(type: instructionTypeMessage, image: nil)
    let header = ChatMessage.header(title: "Delivered: 12:34", alignment: .left)
    let navigations = ChatMessage.navigation(chatMessageNavigations)
    let inputs = ChatMessage.input(chatMessageInputs)

    return [instruction, header, navigations, inputs]
}

