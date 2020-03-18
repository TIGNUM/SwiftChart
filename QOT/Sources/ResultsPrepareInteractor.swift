//
//  ResultsPrepareInteractor.swift
//  QOT
//
//  Created by karmic on 11.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class ResultsPrepareInteractor {

    // MARK: - Properties
    private lazy var workerCalendar = WorkerCalendar()
    private lazy var worker = ResultsPrepareWorker()
    private let presenter: ResultsPreparePresenterInterface!
    private var preparation: QDMUserPreparation?
    private let resultType: ResultType
    private var editKey = Prepare.Key.benefits
    private var newEvent: QDMUserCalendarEvent?

    // MARK: - Init
    init(presenter: ResultsPreparePresenterInterface, _ preparation: QDMUserPreparation?, resultType: ResultType) {
        self.presenter = presenter
        self.preparation = preparation
        self.resultType = resultType
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
        presenter.createListItems(preparation: preparation)
    }
}

// MARK: - ResultsPrepareInteractorInterface
extension ResultsPrepareInteractor: ResultsPrepareInteractorInterface {
    var getType: String {
        return preparation?.type ?? .LEVEL_CRITICAL
    }

    var sectionCount: Int {
        guard let level = preparation?.type else { return 0 }
        return ResultsPrepare.sectionCount(level: level)
    }

    func rowCount(in section: Int) -> Int {
        guard let level = preparation?.type else { return 0 }
        let strategyCount = ((preparation?.strategies.count ?? 0))
        if level == .LEVEL_CRITICAL && section == 8 {
            return strategyCount
        }
        if level == .LEVEL_DAILY && section == 7 {
            return strategyCount
        }
        return 1
    }

    func hideEditIcon(title: String) -> Bool {
        return title != AppTextService.get(.results_prepare_strategies)
    }

    func getDTViewModel(key: Prepare.Key, _ completion: @escaping (DTViewModel, QDMQuestion?) -> Void) {
        editKey = key
        worker.getDTViewModel(key, preparation: preparation, completion)
    }

    func getStrategyIds() -> (relatedId: Int, selectedIds: [Int]) {
        return (relatedId: preparation?.relatedStrategyId ?? 0, selectedIds: preparation?.strategyIds ?? [])
    }

    func updateBenefits(_ benefits: String) {
        preparation?.benefits = benefits
        presenter.createListItems(preparation: preparation)
    }

    func updateIntentions(_ answerIds: [Int]) {
        switch editKey {
        case .feel:
            preparation?.feelAnswerIds = answerIds
            worker.getAnswers(answerIds: answerIds, key: editKey) { [weak self] (answers) in
                self?.preparation?.feelAnswers = answers
                self?.presenter.createListItems(preparation: self?.preparation)
            }
        case .know:
            preparation?.knowAnswerIds = answerIds
            worker.getAnswers(answerIds: answerIds, key: editKey) { [weak self] (answers) in
                self?.preparation?.knowAnswers = answers
                self?.presenter.createListItems(preparation: self?.preparation)
            }
        case .perceived:
            preparation?.preceiveAnswerIds = answerIds
            worker.getAnswers(answerIds: answerIds, key: editKey) { [weak self] (answers) in
                self?.preparation?.preceiveAnswers = answers
                self?.presenter.createListItems(preparation: self?.preparation)
            }
        default: break
        }
    }

    func updateStrategies(_ selectedIds: [Int]) {
        preparation?.strategyIds = selectedIds
        worker.getStrategies(selectedIds) { [weak self] (strategies) in
            self?.preparation?.strategies = strategies ?? []
            self?.presenter.createListItems(preparation: self?.preparation)
        }
    }

    func updatePreparationEvent(event: QDMUserCalendarEvent?) {
        newEvent = event
        preparation?.eventTitle = event?.title
        preparation?.eventDate = event?.startDate
        preparation?.eventExternalUniqueIdentifierId = event?.qotId
        presenter.createListItems(preparation: preparation)
    }

    func updatePreparation(_ completion: @escaping (QDMUserPreparation?) -> Void) {
        worker.updatePreparation(preparation, newEvent, completion)
    }

    func didClickSaveAndContinue() {
        worker.updatePreparation(preparation, newEvent, { _ in })
    }

    func deletePreparation() {
        worker.deletePreparation(preparation)
    }
}

// MARK: - CalendarEventSelectionDelegate
extension ResultsPrepareInteractor: CalendarEventSelectionDelegate {
    func didSelectEvent(_ event: QDMUserCalendarEvent) {
        updatePreparationEvent(event: event)
    }

    func didCreateEvent(_ event: EKEvent?) {
        workerCalendar.importCalendarEvent(event) { [weak self] (userCalendarEvent) in
            self?.workerCalendar.storeLocalEvent(event?.eventIdentifier,
                                                 qdmEventIdentifier: userCalendarEvent?.calendarItemExternalId)
            self?.preparation?.eventIsCreatedFromQOT = true
            self?.updatePreparationEvent(event: userCalendarEvent)
        }
    }
}
