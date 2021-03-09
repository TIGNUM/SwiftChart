//
//  DTPrepareInteractor.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import qot_dal

final class DTPrepareInteractor: DTInteractor {

    // MARK: - Properties
    private lazy var prepareWorker = DTPrepareWorker()
    private var preparations: [QDMUserPreparation] = []

    // MARK: - DTInteractor
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareWorker.getPreparations { [weak self] (preparations, _) in
            self?.preparations = preparations
        }
    }

    override func getTBV(questionAnswerType: String?, questionKey: String?) -> QDMToBeVision? {
        return questionKey == Prepare.QuestionKey.ShowTBV ? tbv : nil
    }

    override func getPreparations(answerKeys: [String]?) -> [QDMUserPreparation] {
        if answerKeys?.contains(Prepare.AnswerKey.PeakPlanTemplate) == true {
            return preparations.filter { $0.type == .LEVEL_CRITICAL }
        }
        return []
    }

    override func getAnswerFilter(questionKey: String?, answerFilter: String?) -> String? {
        if questionKey == Prepare.QuestionKey.BuildCritical {
            let criticalPreparations = preparations.filter { $0.type == .LEVEL_CRITICAL }
            return criticalPreparations.isEmpty ? Prepare.AnswerKey.PeakPlanNew : Prepare.AnswerKey.PeakPlanTemplate
        }
        return answerFilter
    }

    override func getNextQuestion(selection: DTSelectionModel, questions: [QDMQuestion]) -> QDMQuestion? {
        var targetQuestionId = selection.selectedAnswers.first?.targetId(.question)

        // Build Plan
        if targetQuestionId == 100324 {
            targetQuestionId = 100398
        }

        // PERCEIVED
        if targetQuestionId == 100393 || targetQuestionId == 100326 {
            targetQuestionId = 100390
        }

        // KNOW
        if targetQuestionId == 100330 {
            targetQuestionId = 100396
        }

        // TBV
        if targetQuestionId == 100329 {
            targetQuestionId = 100399
        }
        return questions.filter { $0.remoteID == targetQuestionId }.first
    }
}

// MARK: - Private
private extension DTPrepareInteractor {
    func getAnswerIds(_ key: Prepare.Key, _ answers: [SelectedAnswer]) -> [Int] {
        return answers
            .filter { $0.question?.remoteId == key.questionID }
            .flatMap { $0.answers }
            .compactMap { $0.remoteId }
    }

    func createUniqueName(_ defaultName: String, in names: [String]) -> String {
        let existingTitles = names.compactMap({ $0.trimmingCharacters(in: .whitespacesAndNewlines)})
        var hasSameName = false
        for title in existingTitles {
            guard defaultName != title else {
                hasSameName = true
                break
            }
        }
        for title in existingTitles {
            guard defaultName != title else {
                hasSameName = true
                break
            }
        }
        var newName = defaultName
        if hasSameName {
            var postfix = 1
            while existingTitles.contains(newName) {
                newName = defaultName + " \(postfix)"
                postfix += 1
            }
        }
        return newName
    }
}

// MARK: - DTPrepareInteractorInterface
extension DTPrepareInteractor: DTPrepareInteractorInterface {
    func createUserPreparation(from existingPreparation: QDMUserPreparation?,
                               _ completion: @escaping (QDMUserPreparation?) -> Void) {
        let answers = selectedAnswers.flatMap { $0.answers }
        let preparationTypeAnswer = answers.filter { $0.keys.contains(Prepare.AnswerKey.KindOfEvenSelectionCritical) }.first
        var model = CreateUserPreparationModel()
        let preparationNames = preparations.compactMap { $0.name }
        model.level = .LEVEL_CRITICAL
        model.benefits = existingPreparation?.benefits
        model.answerFilter = existingPreparation?.answerFilter ?? String.empty
        model.contentCollectionId = existingPreparation?.contentCollectionId ?? .zero
        model.relatedStrategyId = existingPreparation?.relatedStrategyId ?? .zero
        model.strategyIds = existingPreparation?.strategyIds ?? []
        model.strategyItemIds = existingPreparation?.strategyItemIds ?? []
        model.preceiveAnswerIds = existingPreparation?.preceiveAnswerIds ?? []
        model.knowAnswerIds = existingPreparation?.knowAnswerIds ?? []
        model.feelAnswerIds = existingPreparation?.feelAnswerIds ?? []
        model.eventType = preparationTypeAnswer?.title ?? String.empty
        model.name = createUniqueName(existingPreparation?.eventType ?? String.empty, in: preparationNames)
        self.prepareWorker.createUserPreparation(from: model, completion)
    }

    func getUserPreparationDaily(answer: DTViewModel.Answer, _ completion: @escaping (QDMUserPreparation?) -> Void) {
        let answerFilter = answer.keys.filter { $0.contains("_relationship_") }.first ?? String.empty
        let relatedStrategyId = answer.targetId(.content) ?? .zero
        let preparationNames = preparations.compactMap { $0.name }
        let preparationName = createUniqueName(answer.title, in: preparationNames)
        prepareWorker.getRelatedStrategies(relatedStrategyId) { [weak self] (strategyIds) in
            self?.prepareWorker.getRelatedStrategyItems(relatedStrategyId) { (strategyItemIds) in
                var model = CreateUserPreparationModel()
                model.level = QDMUserPreparation.Level.LEVEL_DAILY
                model.benefits = nil
                model.answerFilter = answerFilter
                model.contentCollectionId = QDMUserPreparation.Level.LEVEL_DAILY.contentID
                model.relatedStrategyId = relatedStrategyId
                model.strategyIds = strategyIds
                model.strategyItemIds = strategyItemIds
                model.eventType = preparationName
                self?.prepareWorker.createUserPreparation(from: model, completion)
            }
        }
    }

    func getUserPreparationCritical(answerFilter: String, _ completion: @escaping (QDMUserPreparation?) -> Void) {
        let answers = selectedAnswers.flatMap { $0.answers }
        let filteredAnswer = answers.filter { $0.keys.contains(Prepare.AnswerKey.KindOfEvenSelectionCritical) }.first
        let perceivedIds = getAnswerIds(.perceived, selectedAnswers)
        let knowIds = getAnswerIds(.know, selectedAnswers)
        let feelIds = getAnswerIds(.feel, selectedAnswers)
        let preparationNames = preparations.compactMap { $0.name }
        let relatedStrategyId = filteredAnswer?.targetId(.content) ?? .zero
        prepareWorker.getRelatedStrategies(relatedStrategyId) { [weak self] (strategyIds) in
            self?.prepareWorker.getRelatedStrategyItems(relatedStrategyId) { (strategyItemIds) in
                var model = CreateUserPreparationModel()
                model.level = .LEVEL_CRITICAL
                model.benefits = self?.inputText
                model.answerFilter = answerFilter
                model.contentCollectionId = QDMUserPreparation.Level.LEVEL_CRITICAL.contentID
                model.relatedStrategyId = filteredAnswer?.targetId(.content) ?? .zero
                model.strategyIds = strategyIds
                model.strategyItemIds = strategyItemIds
                model.preceiveAnswerIds = perceivedIds
                model.knowAnswerIds = knowIds
                model.feelAnswerIds = feelIds
                model.eventType = filteredAnswer?.title ?? String.empty
                model.name = self?.createUniqueName(filteredAnswer?.title ?? String.empty, in: preparationNames)
                self?.prepareWorker.createUserPreparation(from: model, completion)
            }
        }
    }
}

// MARK: - DTShortTBVDelegate
extension DTPrepareInteractor: DTShortTBVDelegate {
    func didDismissShortTBVScene(tbv: QDMToBeVision?) {
        self.tbv = tbv
    }
}
