//
//  PrepareViewModel.swift
//  QOT
//
//  Created by karmic on 23/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import RealmSwift

//protocol ChatBot {
//
//    var message: String { get }
//    var type: Preparation.ChatType { get }
//}

final class PrepareChatBotViewModel {

    // MARK: - Properties

//    private let categories: Results<PrepareCategory>
    private var messages = mockData()
    private var token: NotificationToken?
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var categoryCount: Index {
        return messages.count
    }

    // MARK: - Life Cycle

    init() {

    }
}

protocol ChatMessage {
    var type: ChatMessageType { get }
}

enum ChatMessageType {
    case instructionTyping
    case instruction(text: String, delivered: Date)
    case options(title: String, options: [Option])

    enum Option {
        case navigation
        case input
    }
}

private func mockData() -> [ChatMessage] {
    return [
        ChatMessageType.instruction(text: "Hi Loui", delivered: Date()) as ChatMessage
    ]
}

// add 
