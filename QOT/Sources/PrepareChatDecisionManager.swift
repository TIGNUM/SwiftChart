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
    func showNoContentError(manager: PrepareChatDecisionManager)
}

extension Answer: ChatChoice {}

final class PrepareChatDecisionManager {

    private let questionsService: QuestionsService
    weak var delegate: PrepareChatDecisionManagerDelegate?
    private var questionGroupID: Int? = 100007 // FIXME: Should be set based on settings

    init(service: QuestionsService) {
        self.questionsService = service
    }

    func start() {
        delegate?.setItems([], manager: self)

        if let groupID = questionGroupID, let question = questionsService.prepareQuestions(questionGroupID: groupID).first {
            process(question: question)
        }
    }

    func didSelectChoice(_ choice: Answer) {
        guard let groupID = questionGroupID, let target = questionsService.target(answer: choice, questionGroupID: groupID) else {
            delegate?.showNoContentError(manager: self)
            return
        }

        switch target {
        case .content(let id):
            delegate?.showContent(id: id, manager: self)
        case .question(let id):
            if let question = questionsService.question(id: id) {
                process(question: question)
            }
        }
    }

    private func process(question: Question) {
        var items: [ChatItem<Answer>] = []
        items.append(ChatItem(type: .message(question.title)))
        items.append(deliveredFooter(alignment: .left))

        if let headerText = question.answersDescription {
            items.append(ChatItem(type: .header(headerText, alignment: .left)))
        }

        if let groupID = questionGroupID {
            items.append(ChatItem(type: .header(R.string.localized.prepareChatHeaderPreparations(), alignment: .right)))

            let predicate = NSPredicate(format: "ANY decisions.questionGroupID == %d", groupID)
            let answers = question.answers.filter(predicate)
            let decisions = answers.reduce([AnswerDecision](), { (result, answer) -> [AnswerDecision] in
                return result + Array(answer.decisions)
            })

            let flowDisplayCount = decisions.filter { $0.choiceListDisplay == .flow }.count
            let listDisplayCount = decisions.filter { $0.choiceListDisplay == .list }.count
            let choiceListDisplay: ChoiceListDisplay = flowDisplayCount > listDisplayCount ? .flow : .list

            items.append(ChatItem(type: .choiceList(Array(answers), display: choiceListDisplay)))
            items.append(deliveredFooter(alignment: .right))
        }

        delegate?.appendItems(items, manager: self)
    }

    private func deliveredFooter(date: Date = Date(), alignment: NSTextAlignment) -> ChatItem<Answer> {
        let time = DateFormatter.displayTime.string(from: Date())
        return ChatItem(type: .footer(R.string.localized.prepareChatFooterDeliveredTime(time), alignment: alignment))
    }
}

private extension AnswerDecision {

    var choiceListDisplay: ChoiceListDisplay? {
        guard let target = target else {
            return nil
        }

        switch target {
        case .content:
            return .flow
        case .question:
            return .list
        }
    }
}
