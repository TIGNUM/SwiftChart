//
//  ChatMessageViewModel.swift
//  QOT
//
//  Created by karmic on 23/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

protocol ChatMessageProtocol {

    var type: ChatMessageType { get }
}

enum ChatMessageType {
    case instructionTyping
    case instruction(message: String, delivered: Date)
    case options(title: String, option: Option)

    enum Option {
        case navigation
        case input
    }
}

struct ChatMessage: ChatMessageProtocol {

    var type: ChatMessageType

    init(type: ChatMessageType) {
        self.type = type
    }
}

final class ChatMessageViewModel {

    // MARK: - Properties

    private var messages = mockData()
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var messageCount: Index {
        return messages.count
    }

    func chatMessage(at index: Index) -> ChatMessage {
        return messages[index]
    }
}

private func mockData() -> [ChatMessage] {
    return [
        ChatMessage(type: .instructionTyping),
        ChatMessage(type: .instruction(message: "Hi Louis what are you preparing for? ", delivered: Date())),
        ChatMessage(type: .options(title: "Meeting", option: .navigation)),
        ChatMessage(type: .options(title: "Negotiation", option: .navigation)),
        ChatMessage(type: .options(title: "Presentation", option: .navigation)),
        ChatMessage(type: .options(title: "Business dinner", option: .navigation)),
        ChatMessage(type: .options(title: "Pre-vacation", option: .navigation)),
        ChatMessage(type: .options(title: "Work to home transition", option: .navigation)),
        ChatMessage(type: .options(title: "Normal day ", option: .input)),
        ChatMessage(type: .options(title: "Tough day ", option: .input))
    ]
}
