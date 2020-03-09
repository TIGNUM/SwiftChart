//
//  PrepareResultsInteractor.swift
//  QOT
//
//  Created by karmic on 24.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class PrepareResultInteractor {

    // MARK: - Properties
    private lazy var workerCalendar = WorkerCalendar()
    private let worker: PrepareResultsWorker
    private let presenter: PrepareResultsPresenterInterface
    private let router: PrepareResultsRouterInterface
    private var events: [QDMUserCalendarEvent] = []

    // MARK: - Init
    init(worker: PrepareResultsWorker,
        presenter: PrepareResultsPresenterInterface,
        router: PrepareResultsRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor
    func viewDidLoad() {
        workerCalendar.hasSyncedCalendars { [weak self] available in
            self?.workerCalendar.getCalendarEvents { [weak self] events in
                self?.setUserCalendarEvents(events)
            }
        }
        presenter.registerTableViewCell(worker.getType)
        presenter.setupView()
    }
}

// MARK: - Private
private extension PrepareResultInteractor {
    func setUserCalendarEvents(_ events: [QDMUserCalendarEvent]) {
        self.events.removeAll()
        self.events = events.sorted(by: { (lhs, rhs) -> Bool in
            return lhs.startDate?.compare(rhs.startDate ?? Date()) == .orderedAscending
        }).unique
    }
}

// MARK: - PrepareCheckListInteractorInterface
extension PrepareResultInteractor: PrepareResultsInteractorInterface {
    var getResultType: ResultType {
        return worker.getResultType
    }

    var getType: QDMUserPreparation.Level {
        return worker.getType
    }

    var setReminder: Bool {
        get { return worker.setReminder }
        set { worker.setReminder = newValue }
    }

    var sectionCount: Int {
        return worker.sectionCount
    }

    func rowCount(in section: Int) -> Int {
        return worker.rowCount(in: section)
    }

    func item(at indexPath: IndexPath) -> PrepareResultsType? {
        return worker.item(at: indexPath)
    }

    func presentRelatedArticle(readMoreID: Int) {
        router.presentContent(readMoreID)
    }

    func presentEditStrategyView() {
        let relatedId = worker.suggestedStrategyId
        worker.getSelectedIDs { [weak self] (selectedIds) in
            self?.router.presentEditStrategyView(relatedId, selectedIds)
        }
    }

    func didTapDismissView() {
        if worker.getResultType == .prepareDecisionTree {
            router.dismissChatBotFlow()
        } else {
            router.dismiss()
        }
    }

    func presentEditIntentions(_ key: Prepare.Key) {
        worker.getDTViewModel(key, benefits: nil) { [weak self] (viewModel, question) in
            self?.router.presentEditIntentions(viewModel, question: question)
        }
    }

    func presentEditBenefits(benefits: String?) {
        worker.getDTViewModel(Prepare.Key.benefits, benefits: benefits) { [weak self] (viewModel, question) in
            self?.router.presentEditIntentions(viewModel, question: question)
        }
    }

    func presentMyPreps() {
        router.presentMyPreps()
    }

    func presentCalendarEventSelection() {
        router.presentCalendarEventSelection()
    }

    func updateStrategies(selectedIds: [Int]) {
       worker.updateStrategies(selectedIds: selectedIds)
    }

    func updateIntentions(_ answerIds: [Int]) {
        worker.updateIntentions(answerIds)
    }

    func updateBenefits(_ benefits: String) {
        worker.updateBenefits(benefits)
    }

    func deletePreparation() {
        worker.deletePreparation()
    }

    func updatePreparation(_ completion: @escaping (QDMUserPreparation?) -> Void) {
        worker.updatePreparation(completion)
    }

    func didClickSaveAndContinue() {
        router.presentMyPreps()
        updatePreparation { _ in }
    }

    func presentCalendarPermission(_ permissionType: AskPermission.Kind) {
        router.presentCalendarPermission(permissionType, delegate: self)
    }

    func checkSyncedCalendars() {
        workerCalendar.hasSyncedCalendars { [weak self] (available) in
            guard let strongSelf = self else { return }
            if available == true {
                strongSelf.router.presentCalendarEventSelection()
            } else {
                strongSelf.router.presentCalendarSettings(delegate: strongSelf)
            }
        }
    }
}

// MARK: - AskPermissionDelegate
extension PrepareResultInteractor: AskPermissionDelegate {
    func didFinishAskingForPermission(type: AskPermission.Kind, granted: Bool) {
        if granted {
            router.presentCalendarSettings(delegate: self)
        } else {
//            resetSelectedAnswers()
        }
    }
}

// MARK: - SyncedCalendarsDelegate
extension PrepareResultInteractor: SyncedCalendarsDelegate {
    func didFinishSyncingCalendars(qdmEvents: [QDMUserCalendarEvent]) {
        if qdmEvents.isEmpty {
//            resetSelectedAnswers()
        } else {
//            prepareInteractor?.setUserCalendarEvents(qdmEvents)
//            loadNextQuestion()
        }
    }
}
