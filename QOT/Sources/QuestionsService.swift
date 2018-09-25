//
//  QuestionsService.swift
//  QOT
//
//  Created by Sam Wyndham on 26.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class QuestionsService {

    private let mainRealm: Realm
    private let realmProvider: RealmProvider

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }

    func prepareQuestions(questionGroupID: Int) -> AnyRealmCollection<Question> {
        return questions(for: questionGroupID)
    }

    func question(id: Int) -> Question? {
        return mainRealm.syncableObject(ofType: Question.self, remoteID: id)
    }

    func morningInterviewQuestions(questionGroupID: Int) -> AnyRealmCollection<Question> {
        let predicate = NSPredicate(format: "ANY groups.id == %d AND answers.@count > 0", questionGroupID)
        let results = mainRealm.objects(Question.self).sorted(by: [.sortOrder()]).filter(predicate)

        return AnyRealmCollection(results)
    }

    func morningInterviewTitles(questionGroupID: Int) -> [String] {
        let questions = morningInterviewQuestions(questionGroupID: questionGroupID)
        return Array(questions).compactMap { $0.title }
    }

    func target(answer: Answer, questionGroupID id: Int) -> AnswerDecision.Target? {
        let decisions = answer.decisions.filter(.questionGroupIDis(id))
        for decision in decisions {
            if let target = decision.target {
                switch target {
                case .content(let id):
                    if mainRealm.syncableObject(ofType: ContentCollection.self, remoteID: id) != nil {
                        return target
                    }
                case .question(let id):
                    if question(id: id) != nil {
                        return target
                    }
                default: break
                }
            }
        }
        return nil
    }

    private var questions: [Question] {
        return Array(visionQuestions())
    }

    private var introChatItems: [ChatItem<VisionGeneratorChoice>] {
        guard let question = questionFor(.intro) else { return [] }
        return chatItems(for: question)
    }

    private var instructionChatItems: [ChatItem<VisionGeneratorChoice>] {
        guard let question = questionFor(.instructions) else { return [] }
        return chatItems(for: question)
    }

    private var workChatItems: [ChatItem<VisionGeneratorChoice>] {
        guard let question = questionFor(.work) else { return [] }
        return chatItems(for: question)
    }

    private var homeChatItems: [ChatItem<VisionGeneratorChoice>] {
        guard let question = questionFor(.home) else { return [] }
        return chatItems(for: question)
    }

    private var nextChatItems: [ChatItem<VisionGeneratorChoice>] {
        guard let question = questionFor(.next) else { return [] }
        return chatItems(for: question)
    }

    private var createChatItems: [ChatItem<VisionGeneratorChoice>] {
        guard let question = questionFor(.create) else { return [] }
        return chatItems(for: question)
    }

    private var pictureChatItems: [ChatItem<VisionGeneratorChoice>] {
        guard let question = questionFor(.picture) else { return [] }
        return chatItems(for: question)
    }

    private var reviewChatItems: [ChatItem<VisionGeneratorChoice>] {
        guard let question = questionFor(.review) else { return [] }
        return chatItems(for: question)
    }
}

// MARK: - TBV Generator

extension QuestionsService {

    func visionQuestions() -> AnyRealmCollection<Question> {
        return questions(for: 100041)
    }

    func visionQuestion(for type: VisionGeneratorChoice.QuestionType) -> Question? {
        return (Array(visionQuestions()).filter { $0.key == type.rawValue }).first
    }

    func visonIntroQuestion() -> Question? {
        return visionQuestion(for: .intro)
    }

    func visionLastQuestion() -> Question? {
        return visionQuestion(for: .review)
    }

    func visionQuestion(for targetID: Int) -> Question? {
        return question(id: targetID)
    }

    func visionAnswers() -> [Answer] {
        var answers = [Answer]()
        visionQuestions().forEach { (question: Question) in
            answers.append(contentsOf: question.answers)
        }
        return answers
    }

    var visionChatItems: [VisionGeneratorChoice.QuestionType: [ChatItem<VisionGeneratorChoice>]] {
        return [VisionGeneratorChoice.QuestionType.intro: introChatItems,
                VisionGeneratorChoice.QuestionType.instructions: instructionChatItems,
                VisionGeneratorChoice.QuestionType.work: workChatItems,
                VisionGeneratorChoice.QuestionType.home: homeChatItems,
                VisionGeneratorChoice.QuestionType.next: nextChatItems,
                VisionGeneratorChoice.QuestionType.picture: pictureChatItems,
                VisionGeneratorChoice.QuestionType.create: createChatItems,
                VisionGeneratorChoice.QuestionType.review: reviewChatItems]
    }

    func questionFor(_ type: VisionGeneratorChoice.QuestionType) -> Question? {
        return (questions.filter { $0.key == type.key }).first
    }

    func chatItems(for question: Question) -> [ChatItem<VisionGeneratorChoice>] {
        return generateItems(visionGeneratorMessages(question),
                             followedByChoices: visionGeneratorChoices(question),
                             choiceType: choiceType(for: question))
    }

    func visionGeneratorMessages(_ question: Question) -> [String] {
        return [question.title]
    }

    func visionGeneratorChoices(_ question: Question?) -> [VisionGeneratorChoice] {
        guard let question = question else { return [] }
        let questionType = choiceType(for: question)
        var choices = [VisionGeneratorChoice]()
        for answer in question.answers {
            if questionType == .home || questionType == .work {
                guard isValid(answer: answer) == true else { continue }
            }
            choices.append(VisionGeneratorChoice(title: answer.title,
                                                 type: choiceType(for: question),
                                                 targetID: answer.decisions.first?.targetID,
                                                 target: answer.decisions.first?.target))
        }
        return choices
    }

    private func isValid(answer: Answer) -> Bool {
        let predicate = NSPredicate(format: "collectionID == %d", answer.decisions.first?.targetID ?? 0)
        let contentItems = AnyRealmCollection(mainRealm.objects(ContentItem.self).filter(predicate))
        let filteredItems = contentItems.filter { $0.searchTags.isEmpty == false && $0.searchTags.contains("GENDER_") }
        return filteredItems.isEmpty == false
    }

    func generateItems(_ messages: [String],
                       followedByChoices choices: [VisionGeneratorChoice],
                       choiceType: VisionGeneratorChoice.QuestionType) -> [ChatItem<VisionGeneratorChoice>] {
        var items: [ChatItem<VisionGeneratorChoice>] = []
        let now = Date()
        for (index, message) in messages.enumerated() {
            let date = now.addingTimeInterval(TimeInterval(index))
            let item = messageChatItem(text: message,
                                       date: date,
                                       includeFooter: index == messages.count - 1,
                                       isAutoscrollSnapable: index == 0,
                                       questionType: choiceType)
            items.append(item)
        }
        let choiceListDate = now.addingTimeInterval(TimeInterval(choices.count))
        items.append(choiceListChatItem(choices: choices,
                                        date: choiceListDate,
                                        includeFooter: true,
                                        choiceType: choiceType))
        return items
    }

    func messageChatItem(text: String,
                         date: Date,
                         includeFooter: Bool,
                         isAutoscrollSnapable: Bool,
                         questionType: VisionGeneratorChoice.QuestionType) -> ChatItem<VisionGeneratorChoice> {
        return ChatItem<VisionGeneratorChoice>(type: .message(text),
                                               chatType: .visionGenerator,
                                               alignment: .left,
                                               timestamp: date,
                                               showFooter: includeFooter,
                                               isAutoscrollSnapable: questionType.isAutoscrollSnapable)
    }

    func choiceListChatItem(choices: [VisionGeneratorChoice],
                            date: Date,
                            includeFooter: Bool,
                            choiceType: VisionGeneratorChoice.QuestionType) -> ChatItem<VisionGeneratorChoice> {
        return ChatItem<VisionGeneratorChoice>(type: .choiceList(choices),
                                               chatType: .visionGenerator,
                                               alignment: .right,
                                               timestamp: date,
                                               showFooter: includeFooter,
                                               allowsMultipleSelection: choiceType.multiSelection,
                                               pushDelay: 1)
    }

    func choiceType(for question: Question?) -> VisionGeneratorChoice.QuestionType {
        if let question = question, let type = VisionGeneratorChoice.QuestionType(rawValue: question.key ?? "") {
            return type
        }
        return VisionGeneratorChoice.QuestionType.intro
    }
}

// MARK: - Private

private extension QuestionsService {

    func questions(for questionGroupID: Int) -> AnyRealmCollection<Question> {
        let predicate = NSPredicate(format: "ANY groups.id == %d", questionGroupID)
        let results = mainRealm.objects(Question.self).sorted(by: [.sortOrder()]).filter(predicate)
        return AnyRealmCollection(results)
    }
}
