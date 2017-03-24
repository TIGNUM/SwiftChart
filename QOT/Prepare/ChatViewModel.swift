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

    fileprivate var chatSections: [ChatSection] = []
    fileprivate var timer: Timer?
    fileprivate var mockSections: [ChatSection] = mockData
    let updates = PublishSubject<CollectionUpdate, NoError>()

    init() {
        setupTimer()
    }

    var sectionCount: Index {
        return chatSections.count
    }

    func chatSection(at section: Index) -> ChatSection {
        return chatSections[section]
    }

    func chatSectionData(at indexPath: IndexPath) -> ChatSectionData {
        return chatSections[indexPath.section].data
    }

    func chatSectionDataCount(at section: Index) -> Index {
        switch chatSections[section].data {
        case .chatMessages(let messages): return messages.count
        case .chatNavigations(let navigations): return navigations.count
        case .chatInputs(let inputs): return inputs.count
        }
    }

    func chatNavigation(at indexPath: IndexPath) -> ChatNavigation? {
        return (chatSectionData(at: indexPath) as? [ChatNavigation])?[indexPath.row]
    }

    deinit {
        timer?.invalidate()
    }
}

// MARK - MOCK

extension ChatViewModel {

    fileprivate func setupTimer() {
        let timer = Timer.init(fire: Date(timeIntervalSinceNow: 1), interval: 2, repeats: true) { [unowned self] (timer) in
            if let first = self.mockSections.first {
                let index = self.chatSections.count
                self.mockSections.remove(at: 0)
                self.chatSections.append(first)
                let update = CollectionUpdate.update(deletions: [], insertions: [index], modifications: [])
                self.updates.next(update)
            } else {
                self.timer?.invalidate()
            }
        }

        RunLoop.main.add(timer, forMode: .defaultRunLoopMode)
    }
}

private func messagesSection() -> ChatSection {
    let instructionMessage = ChatMessage.text("Hi Louis what are you preparing for?")
    let instructionFooter = "Delivered at 12:58"
    let insructionData = ChatSectionData.chatMessages([instructionMessage])
    return MockChatSection(header: nil, footer: instructionFooter, data: insructionData)
}

private func navigationSection() -> ChatSection {
    let navigations = [
        ChatNavigation(title: "Meeting"),
        ChatNavigation(title: "Negotiation"),
        ChatNavigation(title: "Presentation"),
        ChatNavigation(title: "Business Dinner"),
        ChatNavigation(title: "Pre-Vacation"),
        ChatNavigation(title: "Work to home transition")
    ]

    return MockChatSection(header: "PREPARATIONS", footer: nil, data: ChatSectionData.chatNavigations(navigations))
}

private func inputSection() -> ChatSection {
    let inputs = [
        ChatInput(title: "Normal day"),
        ChatInput(title: "Tough day")
    ]

    return MockChatSection(header: "DAY PROTOCOL", footer: nil, data: ChatSectionData.chatInputs(inputs))
}

private var mockData: [ChatSection] {
    return [
        messagesSection(),
        navigationSection(),
        inputSection()
    ]
}

protocol ChatSection {
    var header: String? { get }
    var footer: String? { get }
    var data: ChatSectionData { get }
}

private struct MockChatSection: ChatSection {
    let header: String?
    let footer: String?
    let data: ChatSectionData
}

enum ChatSectionData {
    case chatMessages([ChatMessage])
    case chatNavigations([ChatNavigation])
    case chatInputs([ChatInput])

    var chatMessages: [ChatMessage]? {
        switch self {
        case .chatMessages(let messages): return messages
        default: return nil
        }
    }

    var chatNavigations: [ChatNavigation]? {
        switch self {
        case .chatNavigations(let navigations): return navigations
        default: return nil
        }
    }

    var chatInputs: [ChatInput]? {
        switch self {
        case .chatInputs(let inputs): return inputs
        default: return nil
        }
    }

    func chatMessage(at index: Index) -> ChatMessage? {
        return chatMessages?[index]
    }

    func chatNavigation(at index: Index) -> ChatNavigation? {
        return chatNavigations?[index]
    }

    func chatInput(at index: Index) -> ChatInput? {
        return chatInputs?[index]
    }
}

enum ChatMessage {
    case text(String)
    case typing

    var text: String? {
        switch self {
        case .text(let text): return text
        case .typing: return nil
        }
    }
}

struct ChatNavigation {
    let title: String
}

struct ChatInput {
    let title: String
}
