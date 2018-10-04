//
//  PrepareChatDecisionManager.swift
//  QOT
//
//  Created by Sam Wyndham on 23.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import RealmSwift

extension Answer: ChatChoice {}

protocol PrepareChatDecisionManagerDelegate: class {
    func setItems(_ items: [ChatItem<PrepareAnswer>], manager: PrepareChatDecisionManager)
    func appendItems(_ items: [ChatItem<PrepareAnswer>], manager: PrepareChatDecisionManager)
    func showContent(id: Int, manager: PrepareChatDecisionManager, questionID: Int)
    func showNoContentError(manager: PrepareChatDecisionManager)
}

struct PrepareAnswer: ChatChoice {
    let title: String
    let target: AnswerDecision.Target?
}

final class PrepareChatDecisionManager {

    private let questionsService: QuestionsService
    weak var delegate: PrepareChatDecisionManagerDelegate?
    private var questionGroupID: Int = 100007 // FIXME: Should be set based on settings
    private var questionSelectedID: Int = 0

    init(service: QuestionsService) {
        self.questionsService = service
    }

    func start() {
        delegate?.setItems([], manager: self)
        addQuestions()
    }

    func preparationSaved() {
        let now = Date()
        addMessage(R.string.localized.prepareChatPreparationSaved(), timestamp: now, showDeliveredFooter: false)
        addQuestions(timestamp: now.addingTimeInterval(1), isAutoscrollSnapable: false)
    }

    func addQuestions(timestamp: Date = Date(), isAutoscrollSnapable: Bool = true) {
        if let question = questionsService.prepareQuestions(questionGroupID: questionGroupID).first {
            process(question: question, timestamp: timestamp, isAutoscrollSnapable: isAutoscrollSnapable)
        }
    }

    func didSelectChoice(_ choice: PrepareAnswer) {
        guard let target = choice.target else {
            delegate?.showNoContentError(manager: self)
            return
        }

        switch target {
        case .content(let id):
            delegate?.showContent(id: id, manager: self, questionID: questionSelectedID)
        case .question(let id):
            if let question = questionsService.question(id: id) {
                questionSelectedID = id
                process(question: question, timestamp: Date(), isAutoscrollSnapable: true)
            }
        default: return
        }
    }

    func addMessage(_ message: String, timestamp: Date, showDeliveredFooter: Bool) {
        let item: ChatItem<PrepareAnswer> = ChatItem(type: .message(message),
                                                     chatType: .prepare,
                                                     alignment: .left,
                                                     timestamp: timestamp,
                                                     showFooter: showDeliveredFooter,
                                                     isAutoscrollSnapable: true)
        delegate?.appendItems([item], manager: self)
    }

    private func process(question: Question, timestamp: Date, isAutoscrollSnapable: Bool) {
        var items: [ChatItem<PrepareAnswer>] = []
        let botMessage: ChatItem<PrepareAnswer> = ChatItem(type: .message(question.title),
                                                           chatType: .prepare,
                                                           alignment: .left,
                                                           timestamp: timestamp,
                                                           showFooter: true,
                                                           isAutoscrollSnapable: isAutoscrollSnapable)
        items.append(botMessage)
        let answers = Array(question.prepareChatAnswers(groupID: questionGroupID))
        let prepareAnswers: [PrepareAnswer] = answers.map {
            let target = questionsService.target(answer: $0, questionGroupID: questionGroupID)
            return PrepareAnswer(title: $0.title, target: target)
        }
        let item = ChatItem(type: .choiceList(prepareAnswers),
                            chatType: .prepare,
                            alignment: .right,
                            timestamp: timestamp.addingTimeInterval(0.8),
                            showFooter: true,
                            allowsMultipleSelection: true)
        items.append(item)
        delegate?.appendItems(items, manager: self)
    }

    private func deliveredFooter(date: Date) -> String {
        let time = DateFormatter.displayTime.string(from: Date())
        return R.string.localized.prepareChatFooterDeliveredTime(time)
    }
}

private extension Question {

    func prepareChatAnswers(groupID: Int) -> Results<Answer> {
        let predicate = NSPredicate(format: "ANY decisions.questionGroupID == %d", groupID)
        return answers.filter(predicate)
    }
}
