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

//    fileprivate var messages: [ChatSection] = []
    fileprivate var timer: Timer?
    fileprivate var mockSections: [ChatSection] = mockData
    let updates = PublishSubject<CollectionUpdate, NoError>()

    init() {
        setupTimer()
    }

    var sectionCount: Index {
        return mockSections.count
    }

    func chatSection(at section: Index) -> ChatSection {
        return mockSections[section]
    }

    func chatSectionData(at indexPath: IndexPath) -> ChatSectionData {
        return mockSections[indexPath.section].data
    }

    func chatSectionDataCount(at section: Index) -> Index {
        switch mockSections[section].data {
        case .messages(let messages): return messages.count
        case .navigations(let navigations): return navigations.count
        case .inputs(let inputs): return inputs.count
        }
    }

    deinit {
        timer?.invalidate()
        mockSections.removeAll()
    }
}

// MARK - MOCK

extension ChatViewModel {

    fileprivate func setupTimer() {
        var index = 0
        let timer = Timer.init(fire: Date(timeIntervalSinceNow: 3), interval: 3, repeats: true) { [unowned self] (timer) in
            if self.mockSections.isEmpty == false {
                self.mockSections.remove(at: 0)
                let update = CollectionUpdate.update(deletions: [], insertions: [index], modifications: [])
                index += 1
                self.updates.next(update)
            } else {
                self.timer?.invalidate()
            }
        }

        RunLoop.main.add(timer, forMode: .defaultRunLoopMode)
    }
}

private func messagesSection() -> ChatSection {
    let instructionMessage = Message.text("Hi Louis what are you preparing for?")
    let instructionFooter = "Delivered at 12:58"
    let insructionData = ChatSectionData.messages([instructionMessage])
    return MockChatSection(header: nil, footer: instructionFooter, data: insructionData)
}

private func navigationSection() -> ChatSection {
    let navigations = [
        Navigation(title: "Meeting"),
        Navigation(title: "Negotiation"),
        Navigation(title: "Presentation"),
        Navigation(title: "Business Dinner"),
        Navigation(title: "Pre-Vacation"),
        Navigation(title: "Work to home transition")
    ]

    return MockChatSection(header: "PREPARATIONS", footer: nil, data: ChatSectionData.navigations(navigations))
}

private func inputSection() -> ChatSection {
    let inputs = [
        Input(title: "Normal day"),
        Input(title: "Tough day")
    ]

    return MockChatSection(header: "DAY PROTOCOL", footer: nil, data: ChatSectionData.inputs(inputs))
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
    case messages([Message])
    case navigations([Navigation])
    case inputs([Input])
}

enum Message {
    case text(String)
    case typing
}

struct Navigation {
    let title: String
}

struct Input {
    let title: String
}
