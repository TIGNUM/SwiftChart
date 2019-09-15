//
//  DTPrepareInteractor.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTPrepareInteractor: DTInteractor {

    // MARK: - Properties
    private lazy var prepareWorker: DTPrepareWorker? = DTPrepareWorker()
    private var events: [QDMUserCalendarEvent] = []
    private var preparations: [QDMUserPreparation] = []
    private var eventsInitiated = false
    private var preparationsInitiated = false
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

    override func loadNextQuestion(selection: DTSelectionModel) {
        if selection.question?.key == Prepare.QuestionKey.Intro {
            checkCalendarPermissionForSelection(selection)
        } else {
            super.loadNextQuestion(selection: selection)
        }
    }

    override func getEvents(questionAnswerType: String?, questionKey: String?) -> [QDMUserCalendarEvent] {
        return events
    }

    override func getPreparations(questionKey: String?, answerKeys: [String]?) -> [QDMUserPreparation] {
        return preparations
    }
}

// MARK: - DTPrepareInteractorInterface
extension DTPrepareInteractor: DTPrepareInteractorInterface {
    func getUserPreparation(answer: DTViewModel.Answer,
                            event: DTViewModel.Event?,
                            completion: @escaping (QDMUserPreparation?) -> Void) {
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
}

// MARK: - Private
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
