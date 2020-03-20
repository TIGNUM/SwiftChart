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
            return criticalPreparations.isEmpty ? Prepare.AnswerKey.PeakPlanNew : answerFilter
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
        prepareWorker?.getRelatedStrategies(eventAnswer?.targetId(.content) ?? 0) { [weak self] (strategyIds) in
            var model = CreateUserPreparationModel()
            model.level = .LEVEL_CRITICAL
            model.benefits = self?.inputText
            model.answerFilter = Prepare.AnswerFilter
            model.contentCollectionId = QDMUserPreparation.Level.LEVEL_CRITICAL.contentID
            model.relatedStrategyId = eventAnswer?.targetId(.content) ?? 0
            model.strategyIds = strategyIds
            model.preceiveAnswerIds = perceivedIds
            model.knowAnswerIds = knowIds
            model.feelAnswerIds = feelIds
            model.eventType = eventAnswer?.title ?? ""
            self?.prepareWorker?.createUserPreparation(from: model, completion)
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
        model.level = existingPrep?.type ?? .LEVEL_CRITICAL
        model.benefits = existingPrep?.benefits
        model.answerFilter = existingPrep?.answerFilter
        model.contentCollectionId = existingPrep?.contentCollectionId ?? 0
        model.relatedStrategyId = existingPrep?.relatedStrategyId ?? 0
        model.strategyIds = existingPrep?.strategyIds ?? []
        model.preceiveAnswerIds = existingPrep?.preceiveAnswerIds ?? []
        model.knowAnswerIds = existingPrep?.knowAnswerIds ?? []
        model.feelAnswerIds = existingPrep?.feelAnswerIds ?? []
        model.eventType = eventAnswer?.title ?? ""
        self.prepareWorker?.createUserPreparation(from: model, completion)
    }

    func getUserPreparation(answer: DTViewModel.Answer,
                            event: DTViewModel.Event?,
                            _ completion: @escaping (QDMUserPreparation?) -> Void) {
        let answerFilter = answer.keys.filter { $0.contains("_relationship_") }.first ?? ""
        let relatedStrategyId = answer.targetId(.content) ?? 0
        let eventType = answer.title
        prepareWorker?.createPreparationDaily(answerFilter: answerFilter,
                                              relatedStategyId: relatedStrategyId,
                                              eventType: eventType,
                                              completion)
    }
}

// MARK: - DTShortTBVDelegate
extension DTPrepareInteractor: DTShortTBVDelegate {
    func didDismissShortTBVScene(tbv: QDMToBeVision?) {
        self.tbv = tbv
    }
}
