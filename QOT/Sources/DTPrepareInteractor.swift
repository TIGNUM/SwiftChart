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
    private lazy var prepareWorker: DTPrepareWorker? = DTPrepareWorker()
    private var preparations: [QDMUserPreparation] = []

    // MARK: - DTInteractor
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareWorker?.getPreparations { [weak self] (preparations, _) in
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
        if targetQuestionId == 100393 {
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

// MARK: - DTPrepareInteractorInterface
extension DTPrepareInteractor: DTPrepareInteractorInterface {
    //TODO Unify to one single createPrep func with ServiceModel.
    func getUserPreparation(event: DTViewModel.Event?,
                            _ completion: @escaping (QDMUserPreparation?) -> Void) {
        let answers = selectedAnswers.flatMap { $0.answers }
        let eventAnswer = answers.filter { $0.keys.contains(Prepare.AnswerKey.KindOfEvenSelectionCritical) }.first
        let perceivedIds = getAnswerIds(.perceived, selectedAnswers)
        let knowIds = getAnswerIds(.know, selectedAnswers)
        let feelIds = getAnswerIds(.feel, selectedAnswers)
        let preparationNames = preparations.compactMap { $0.name }
        let relatedStrategyId = eventAnswer?.targetId(.content) ?? 0
        prepareWorker?.getRelatedStrategies(relatedStrategyId) { [weak self] (strategyIds) in
            self?.prepareWorker?.getRelatedStrategyItems(relatedStrategyId) { (strategyItemIds) in
                var model = CreateUserPreparationModel()
                model.level = .LEVEL_CRITICAL
                model.benefits = self?.inputText
                model.answerFilter = Prepare.AnswerFilter
                model.contentCollectionId = QDMUserPreparation.Level.LEVEL_CRITICAL.contentID
                model.relatedStrategyId = eventAnswer?.targetId(.content) ?? 0
                model.strategyIds = strategyIds
                model.strategyItemIds = strategyItemIds
                model.preceiveAnswerIds = perceivedIds
                model.knowAnswerIds = knowIds
                model.feelAnswerIds = feelIds
                model.eventType = eventAnswer?.title ?? ""
                model.name = self?.createUniqueName(eventAnswer?.title ?? "", in: preparationNames)
                self?.prepareWorker?.createUserPreparation(from: model, completion)
            }
        }
    }

    private func getAnswerIds(_ key: Prepare.Key, _ answers: [SelectedAnswer]) -> [Int] {
        return answers.filter { $0.question?.remoteId == key.questionID }.flatMap { $0.answers }.compactMap { $0.remoteId }
    }

    func getUserPreparation(event: DTViewModel.Event?,
                            calendarEvent: DTViewModel.Event?,
                            _ completion: @escaping (QDMUserPreparation?) -> Void) {
        let existingPrep = preparations.filter { $0.remoteID == event?.remoteId }.first
        let answers = selectedAnswers.flatMap { $0.answers }
        let eventAnswer = answers.filter { $0.keys.contains(Prepare.AnswerKey.KindOfEvenSelectionCritical) }.first
        var model = CreateUserPreparationModel()
        let preparationNames = preparations.compactMap { $0.name }
        model.level = existingPrep?.type ?? .LEVEL_CRITICAL
        model.benefits = existingPrep?.benefits
        model.answerFilter = existingPrep?.answerFilter
        model.contentCollectionId = existingPrep?.contentCollectionId ?? 0
        model.relatedStrategyId = existingPrep?.relatedStrategyId ?? 0
        model.strategyIds = existingPrep?.strategyIds ?? []
        model.strategyItemIds = existingPrep?.strategyItemIds ?? []
        model.preceiveAnswerIds = existingPrep?.preceiveAnswerIds ?? []
        model.knowAnswerIds = existingPrep?.knowAnswerIds ?? []
        model.feelAnswerIds = existingPrep?.feelAnswerIds ?? []
        model.eventType = eventAnswer?.title ?? ""
        model.name = createUniqueName(existingPrep?.eventType ?? "", in: preparationNames)
        self.prepareWorker?.createUserPreparation(from: model, completion)
    }

    func getUserPreparation(answer: DTViewModel.Answer,
                            event: DTViewModel.Event?,
                            _ completion: @escaping (QDMUserPreparation?) -> Void) {
        let answerFilter = answer.keys.filter { $0.contains("_relationship_") }.first ?? ""
        let relatedStrategyId = answer.targetId(.content) ?? 0
        let preparationNames = preparations.compactMap { $0.name }
        let eventType = createUniqueName(answer.title, in: preparationNames)
        prepareWorker?.createPreparationDaily(answerFilter: answerFilter,
                                              relatedStategyId: relatedStrategyId,
                                              eventType: eventType,
                                              completion)
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

// MARK: - DTShortTBVDelegate
extension DTPrepareInteractor: DTShortTBVDelegate {
    func didDismissShortTBVScene(tbv: QDMToBeVision?) {
        self.tbv = tbv
    }
}
