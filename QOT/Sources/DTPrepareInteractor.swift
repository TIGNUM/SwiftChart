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
    private var events: [QDMUserCalendarEvent] = []
    private var preparations: [QDMUserPreparation] = []
    private var eventsInitiated = false
    private var preparationsInitiated = false
    private var tbv: QDMToBeVision?
    private var event: EKEvent?
    var preparePresenter: DTPreparePresenterInterface?

    // MARK: - DTInteractor
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareWorker?.getEvents { [weak self] (events, initiated) in
            self?.events = events
            self?.eventsInitiated = initiated
        }
        prepareWorker?.getPreparations { [weak self] (preparations, initiated) in
            self?.preparations = preparations
            self?.preparationsInitiated = initiated
        }
    }

    override func getUsersTBV(_ completion: @escaping (QDMToBeVision?, Bool) -> Void) {
        super.getUsersTBV { (tbv, initiated) in
            self.tbv = tbv
            completion(tbv, initiated)
        }
    }

    override func loadNextQuestion(selection: DTSelectionModel) {
        if selection.question?.key == Prepare.QuestionKey.Intro {
            checkCalendarPermissionForSelection(selection)
        } else {
            super.loadNextQuestion(selection: selection)
        }
    }

    override func getTBV(questionAnswerType: String?, questionKey: String?) -> QDMToBeVision? {
        return questionKey == Prepare.QuestionKey.ShowTBV ? tbv : nil
    }

    override func getEvents(questionKey: String?) -> [QDMUserCalendarEvent] {
        return Prepare.isCalendarEventSelection(questionKey ?? "") ? events : []
    }

    override func getPreparations(answerKeys: [String]?) -> [QDMUserPreparation] {
        return answerKeys?.contains(Prepare.AnswerKey.PeakPlanTemplate) == true ? preparations : []
    }

    override func getAnswerFilter(questionKey: String?, answerFilter: String?) -> String? {
        if questionKey == Prepare.QuestionKey.BuildCritical && preparations.isEmpty {
            return Prepare.AnswerKey.PeakPlanNew
        }
        return answerFilter
    }
}

// MARK: - DTPrepareInteractorInterface
extension DTPrepareInteractor: DTPrepareInteractorInterface {
    //TODO Unify to one single createPrep func with ServiceModel.
    func getUserPreparation(event: DTViewModel.Event?,
                            _ completion: @escaping (QDMUserPreparation?) -> Void) {
        let answers = selectedAnswers.flatMap { $0.answers }
        let eventAnswer = answers.filter { $0.keys.contains(Prepare.AnswerKey.KindOfEvenSelectionCritical) }.first
        let event = events.filter { $0.remoteID == event?.remoteId }.first ?? QDMUserCalendarEvent()
        let perceivedIds = getAnswerIds(.perceived, selectedAnswers)
        let knowIds = getAnswerIds(.know, selectedAnswers)
        let feelIds = getAnswerIds(.feel, selectedAnswers)
        prepareWorker?.getRelatedStrategies(eventAnswer?.targetId(.content) ?? 0) { [weak self] (strategyIds) in
            self?.prepareWorker?.createUserPreparation(level: .LEVEL_CRITICAL,
                                                       benefits: self?.inputText,
                                                       answerFilter: Prepare.AnswerFilter,
                                                       contentCollectionId: QDMUserPreparation.Level.LEVEL_CRITICAL.contentID,
                                                       relatedStrategyId: eventAnswer?.targetId(.content) ?? 0,
                                                       strategyIds: strategyIds,
                                                       preceiveAnswerIds: perceivedIds,
                                                       knowAnswerIds: knowIds,
                                                       feelAnswerIds: feelIds,
                                                       eventType: eventAnswer?.title ?? "",
                                                       event: event,
                                                       completion)
        }
    }

    private func getAnswerIds(_ key: Prepare.Key, _ answers: [SelectedAnswer]) -> [Int] {
        return answers.filter { $0.question?.remoteId == key.questionID }.flatMap { $0.answers }.compactMap { $0.remoteId }
    }

    func getUserPreparation(event: DTViewModel.Event?,
                            calendarEvent: DTViewModel.Event?,
                            _ completion: @escaping (QDMUserPreparation?) -> Void) {
        let existingPrep = preparations.filter { $0.remoteID == event?.remoteId }.first
        let calendarEvent = events.filter { $0.remoteID == calendarEvent?.remoteId }.first
        let answers = selectedAnswers.flatMap { $0.answers }
        let eventAnswer = answers.filter { $0.keys.contains(Prepare.AnswerKey.KindOfEvenSelectionCritical) }.first
        self.prepareWorker?.createUserPreparation(level: existingPrep?.type ?? .LEVEL_CRITICAL,
                                                  benefits: existingPrep?.benefits,
                                                  answerFilter: existingPrep?.answerFilter,
                                                  contentCollectionId: existingPrep?.contentCollectionId ?? 0,
                                                  relatedStrategyId: existingPrep?.relatedStrategyId ?? 0,
                                                  strategyIds: existingPrep?.strategyIds ?? [],
                                                  preceiveAnswerIds: existingPrep?.preceiveAnswerIds ?? [],
                                                  knowAnswerIds: existingPrep?.knowAnswerIds ?? [],
                                                  feelAnswerIds: existingPrep?.feelAnswerIds ?? [],
                                                  eventType: eventAnswer?.title ?? "",
                                                  event: calendarEvent ?? QDMUserCalendarEvent(),
                                                  completion)
    }

    func getUserPreparation(answer: DTViewModel.Answer,
                            event: DTViewModel.Event?,
                            _ completion: @escaping (QDMUserPreparation?) -> Void) {
        let answerFilter = answer.keys.filter { $0.contains("_relationship_") }.first ?? ""
        let relatedStrategyId = answer.targetId(.content) ?? 0
        let eventType = answer.title
        let userEvent = events.filter { $0.remoteID == event?.remoteId }.first ?? QDMUserCalendarEvent()
        prepareWorker?.createPreparationDaily(answerFilter: answerFilter,
                                              relatedStategyId: relatedStrategyId,
                                              eventType: eventType,
                                              event: userEvent,
                                              completion)
    }

    func setCreatedCalendarEvent(_ event: EKEvent?) {
        self.event = event
    }
}

// MARK: - CalendarPermission
private extension DTPrepareInteractor {
    func checkCalendarPermissionForSelection(_ selection: DTSelectionModel) {
        let answerKeys = selection.selectedAnswers.first?.keys ?? []
        if answerKeys.contains(Prepare.AnswerKey.EventTypeSelectionDaily) ||
            answerKeys.contains(Prepare.AnswerKey.EventTypeSelectionCritical) {

            switch CalendarPermission().authorizationStatus {
            case .notDetermined:
                preparePresenter?.presentCalendarPermission(.calendar)
            case .denied, .restricted:
                preparePresenter?.presentCalendarPermission(.calendarOpenSettings)
            default:
                super.loadNextQuestion(selection: selection)
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
