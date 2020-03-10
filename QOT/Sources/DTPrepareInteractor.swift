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
    private lazy var workerCalendar: WorkerCalendar? = WorkerCalendar()
    private var events: [QDMUserCalendarEvent] = []
    private var preparations: [QDMUserPreparation] = []
    private var createdUserCalendarEvent: QDMUserCalendarEvent?
    var preparePresenter: DTPreparePresenterInterface?

    var calendarSettings: [QDMUserCalendarSetting] = []

    // MARK: - DTInteractor
    override func viewDidLoad() {
        super.viewDidLoad()
        workerCalendar?.hasSyncedCalendars { [weak self] available in
            self?.workerCalendar?.getCalendarEvents { [weak self] events in
                self?.setUserCalendarEvents(events)
            }
        }
        prepareWorker?.getPreparations { [weak self] (preparations, _) in
            self?.preparations = preparations
        }
    }

    override func getTBV(questionAnswerType: String?, questionKey: String?) -> QDMToBeVision? {
        return questionKey == Prepare.QuestionKey.ShowTBV ? tbv : nil
    }

    override func getEvents(questionKey: String?) -> [QDMUserCalendarEvent] {
        workerCalendar?.getCalendarSettings({ [weak self] (settings) in
            self?.calendarSettings = settings
        })
        return Prepare.isCalendarEventSelection(questionKey ?? "") ? events : []
    }

    override func getCalendarSetting() -> [QDMUserCalendarSetting] {
        return calendarSettings
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
}

// MARK: - DTPrepareInteractorInterface
extension DTPrepareInteractor: DTPrepareInteractorInterface {
    //TODO Unify to one single createPrep func with ServiceModel.
    func getUserPreparation(event: DTViewModel.Event?,
                            _ completion: @escaping (QDMUserPreparation?) -> Void) {
        let answers = selectedAnswers.flatMap { $0.answers }
        let eventAnswer = answers.filter { $0.keys.contains(Prepare.AnswerKey.KindOfEvenSelectionCritical) }.first
        let event = createdUserCalendarEvent ?? events.filter { $0.remoteID == event?.remoteId }.first
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
            model.event = event ?? QDMUserCalendarEvent()
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
        let calendarEvent = createdUserCalendarEvent ?? events.filter { $0.remoteID == calendarEvent?.remoteId }.first
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
        model.event = calendarEvent ?? QDMUserCalendarEvent()
        self.prepareWorker?.createUserPreparation(from: model, completion)
    }

    func getUserPreparation(answer: DTViewModel.Answer,
                            event: DTViewModel.Event?,
                            _ completion: @escaping (QDMUserPreparation?) -> Void) {
        let answerFilter = answer.keys.filter { $0.contains("_relationship_") }.first ?? ""
        let relatedStrategyId = answer.targetId(.content) ?? 0
        let eventType = answer.title
        let userEvent = createdUserCalendarEvent ?? events.filter { $0.remoteID == event?.remoteId }.first
        prepareWorker?.createPreparationDaily(answerFilter: answerFilter,
                                              relatedStategyId: relatedStrategyId,
                                              eventType: eventType,
                                              event: userEvent ?? QDMUserCalendarEvent(),
                                              completion)
    }

    func setCreatedCalendarEvent(_ event: EKEvent?, _ completion: @escaping (Bool) -> Void) {
        workerCalendar?.importCalendarEvent(event) { [weak self] (userCalendarEvent) in
            self?.workerCalendar?.storeLocalEvent(event?.eventIdentifier,
                                                  qdmEventIdentifier: userCalendarEvent?.calendarItemExternalId)
            self?.createdUserCalendarEvent = userCalendarEvent
            completion(userCalendarEvent != nil)
        }
    }

    func setUserCalendarEvents(_ events: [QDMUserCalendarEvent]) {
        self.events.removeAll()
        self.events = events.sorted(by: { (lhs, rhs) -> Bool in
            return lhs.startDate?.compare(rhs.startDate ?? Date()) == .orderedAscending
        }).unique
    }

    func removeCreatedCalendarEvent() {
        let externalIdentifier = createdUserCalendarEvent?.storedExternalIdentifier.components(separatedBy: "[//]").first
        workerCalendar?.deleteLocalEvent(externalIdentifier)
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
                workerCalendar?.hasSyncedCalendars { [weak self] available in
                    if available == true {
                        self?.loadNextQuestion(selection: selection)
                    } else {
                        self?.preparePresenter?.presentCalendarSettings()
                    }
                }
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
