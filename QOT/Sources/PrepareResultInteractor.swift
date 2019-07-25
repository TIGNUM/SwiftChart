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

    private let worker: PrepareResultsWorker
    private let presenter: PrepareResultsPresenterInterface
    private let router: PrepareResultsRouterInterface

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
        presenter.registerTableViewCell(worker.getType)
        presenter.setupView()
    }
}

// MARK: - PrepareCheckListInteractorInterface

extension PrepareResultInteractor: PrepareResultsInteractorInterface {
    var getType: QDMUserPreparation.Level {
        return worker.getType
    }

    var saveToICal: Bool {
        get { return worker.saveToICal }
        set { worker.saveToICal = newValue }
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
        router.presentRelatedArticle(readMoreID: readMoreID)
    }

    func didClickSaveAndContinue() {
        worker.updatePreparation { [weak self] (preparation) in
            self?.router.didClickSaveAndContinue()
        }
    }

    func deletePreparationIfNeeded() {
        worker.deletePreparationIfNeeded { [weak self] in
            self?.router.didClickSaveAndContinue()
        }
    }

    func presentEditStrategyView() {
        let relatedId = worker.suggestedStrategyId
        worker.getSelectedIDs { [weak self] (selectedIds) in
            self?.router.presentEditStrategyView(relatedId, selectedIds)
        }
    }

    func presentEditIntentions(_ key: Prepare.Key) {
        var ids = [Int]()
        switch key {
        case .perceived: ids = worker.preceiveAnswerIds
        case .know: ids = worker.knowAnswerIds
        case .feel: ids = worker.feelAnswerIds
        default: break
        }
        worker.generateSelectedAnswers(ids, key) { [weak self] (answers) in
            self?.router.presentEditIntentions(answers, key, answerFilter: self?.worker.answerFilter)
        }
    }

    func presentEditBenefits(benefits: String?, questionID: Int) {
        router.presentEditBenefits(benefits: benefits, questionID: questionID)
    }

    func updateStrategies(selectedIds: [Int]) {
       worker.updateStrategies(selectedIds: selectedIds)
    }

    func updateIntentions(_ answers: [DecisionTreeModel.SelectedAnswer], _ key: Prepare.Key) {
        worker.updateIntentions(answers, key)
    }

    func updateBenefits(_ benefits: String) {
       worker.updateBenefits(benefits)
    }
}
