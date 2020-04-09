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

    // MARK: - Init
    init(presenter: ResultsPreparePresenterInterface, _ preparation: QDMUserPreparation?, resultType: ResultType) {
        self.presenter = presenter
        self.preparation = preparation
        self.resultType = resultType
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
        updatePreparationStrategisIfNeeded { [weak self] in
            self?.presenter.createListItems(preparation: self?.preparation)
        }
    }
}

// MARK: - Private
private extension ResultsPrepareInteractor {
    func updatePreparationStrategisIfNeeded(_ completion: @escaping () -> Void) {
        if preparation?.strategyIds.isEmpty == true,
            let relatedStrategyId = preparation?.relatedStrategyId {
            getDefaultStrategies(relatedStrategyId) { [weak self] (strategies) in
                self?.preparation?.strategies = strategies ?? []
                self?.preparation?.strategyIds = strategies?.compactMap { $0.remoteID } ?? []
                completion()
            }
        } else {
            completion()
        }
    }

    func getDefaultStrategies(_ relatedStrategyID: Int?, _ completion: @escaping (([QDMContentCollection]?) -> Void)) {
        if let relatedStrategyID = relatedStrategyID {
            ContentService.main.getContentCollectionById(relatedStrategyID) { content in
                var relatedIds = content?.relatedContentIDsPrepareDefault ?? []
                relatedIds.append(contentsOf: content?.relatedContentItemIDs ?? [])
                ContentService.main.getContentCollectionsByIds(relatedIds, completion)
            }
        } else {
            completion([])
        }
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
        let strategyCount = (preparation?.strategies.count ?? 0)
        let strytegyItemCount = (preparation?.strategyItems.count ?? 0)
        if (level == .LEVEL_CRITICAL && section == 8) || (level == .LEVEL_DAILY && section == 7) {
            return strategyCount
        }
        if (level == .LEVEL_CRITICAL && section == 9) || (level == .LEVEL_DAILY && section == 8) {
            return strytegyItemCount
        }
        return 1
    }

    func hideEditIcon(title: String) -> Bool {
        return title != AppTextService.get(.results_prepare_strategies)
    }

    func hasEvent() -> Bool {
        return preparation?.event != nil
    }

    func getDTViewModel(key: Prepare.Key, _ completion: @escaping (DTViewModel, QDMQuestion?) -> Void) {
        editKey = key
        worker.getDTViewModel(key, preparation: preparation, completion)
    }

    func getStrategyIds() -> (relatedId: Int, selectedIds: [Int], selectedItemIds: [Int]) {
        let strategyIds = preparation?.strategyIds ?? []
        let strategyItemIds = preparation?.strategyItemIds ?? []
        return (relatedId: preparation?.relatedStrategyId ?? 0, strategyIds, strategyItemIds)
    }

    func updateBenefits(_ benefits: String) {
        preparation?.benefits = benefits
        presenter.createListItems(preparation: preparation)
    }

    func updateTitle(_ title: String) {
        preparation?.updatedName = title
        worker.updatePreparation(preparation, nil, { _ in })
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

    func updateStrategies(_ selectedIds: [Int], selectedItemIds: [Int]) {
        preparation?.strategyIds = selectedIds.filter { $0 != 0 }
        preparation?.strategyItemIds = selectedItemIds.filter { $0 != 0 }
        worker.getStrategies(selectedIds, selectedItemIds) { [weak self] (strategies, strategyItems) in
            self?.preparation?.strategies = strategies ?? []
            self?.preparation?.strategyItems = strategyItems ?? []
            self?.presenter.createListItems(preparation: self?.preparation)
        }
    }

    func updatePreparationEvent(event: QDMUserCalendarEvent?) {
        preparation?.updatedName = event?.title
        worker.updatePreparation(preparation, event) { (preparation) in
            self.preparation = preparation
            self.presenter.createListItems(preparation: preparation)
        }
    }

    func updatePreparation(_ completion: @escaping (QDMUserPreparation?) -> Void) {
        worker.updatePreparation(preparation, nil, completion)
    }

    func removePreparationCalendarEvent() {
        worker.removePreparationCalendarEvent(preparation) { (preparation) in
            self.preparation = preparation
            self.presenter.createListItems(preparation: preparation)
        }
    }

    func didClickSaveAndContinue() {
        worker.updatePreparation(preparation, nil, { _ in })
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
