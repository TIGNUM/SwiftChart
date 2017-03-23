//
//  PrepareViewModel.swift
//  QOT
//
//  Created by karmic on 23/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class PrepareChatBotViewModel {

    // MARK: - Properties

    private var messages = mockData()
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var messageCount: Index {
        return messages.count
    }
}

protocol ChatMessage {
    var type: ChatMessageType { get }
}

enum ChatMessageType {
    case instructionTyping
    case instruction(text: String, delivered: Date)
    case options(title: String, option: Option)

    enum Option {
        case navigation
        case input
    }
}

private func mockData() -> [ChatMessageType] {
    return [
        ChatMessageType.instructionTyping,
        ChatMessageType.instruction(text: "Hi Louis what are you preparing for? ", delivered: Date()),
        ChatMessageType.options(title: "Meeting", option: .navigation),
        ChatMessageType.options(title: "Negotiation", option: .navigation),
        ChatMessageType.options(title: "Presentation", option: .navigation),
        ChatMessageType.options(title: "Business dinner", option: .navigation),
        ChatMessageType.options(title: "Pre-vacation", option: .navigation),
        ChatMessageType.options(title: "Work to home transition", option: .navigation),
        ChatMessageType.options(title: "Normal day ", option: .input),
        ChatMessageType.options(title: "Tough day ", option: .input)
    ]
}
