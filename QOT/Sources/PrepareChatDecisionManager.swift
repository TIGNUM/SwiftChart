//
//  PrepareChatDecisionManager.swift
//  QOT
//
//  Created by Sam Wyndham on 23.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol PrepareChatDecisionManagerDelegate: class {

    func setItems(_ items: [ChatItem<Answer>], manager: PrepareChatDecisionManager)
    func appendItems(_ items: [ChatItem<Answer>], manager: PrepareChatDecisionManager)
    func showContent(id: Int, manager: PrepareChatDecisionManager)
}

extension Answer: ChatChoice {
    var title: String {
        return text
    }
}

final class PrepareChatDecisionManager {

    private let questionsService: QuestionsService
    weak var delegate: PrepareChatDecisionManagerDelegate?

    init(service: QuestionsService) {
        self.questionsService = service
    }

    func start() {
        delegate?.setItems([], manager: self)

        if let question = questionsService.prepareQuestions().first {
            process(question: question)
        }
    }

    func didSelectChoice(_ choice: Answer) {
        if let next = choice.next {
            switch next {
            case .content(let id):
                delegate?.showContent(id: id, manager: self)
            case .question(let id):
                if let question = questionsService.question(id: id) {
                    process(question: question)
                }
            }
        }
    }

    private func process(question: Question) {
        var items: [ChatItem<Answer>] = []
        items.append(ChatItem(type: .message(question.text)))
        items.append(deliveredFooter(alignment: .left))

        if let headerText = question.answersDescription {
            items.append(ChatItem(type: .header(headerText, alignment: .left)))
        }

        items.append(chatItemForAnswers(Array(question.answers)))
        items.append(deliveredFooter(alignment: .right))

        delegate?.appendItems(items, manager: self)
    }

    private func chatItemForAnswers(_ answers: [Answer]) -> ChatItem<Answer> {
        let flowDisplayCount = answers.filter { $0.choiceListDisplay == .flow }.count
        let listDisplayCount = answers.filter { $0.choiceListDisplay == .list }.count
        let choiceListDisplay: ChoiceListDisplay = flowDisplayCount > listDisplayCount ? .flow : .list
        return ChatItem(type: .choiceList(answers, display: choiceListDisplay))
    }

    private func deliveredFooter(date: Date = Date(), alignment: NSTextAlignment) -> ChatItem<Answer> {
        let time = DateFormatter.displayTime.string(from: Date())
        return ChatItem(type: .footer("Delivered at \(time)", alignment: alignment))
    }
}

private extension Answer {

    var choiceListDisplay: ChoiceListDisplay? {
        guard let next = next else {
            return nil
        }

        switch next {
        case .content:
            return .flow
        case .question:
            return .list
        }
    }
}
