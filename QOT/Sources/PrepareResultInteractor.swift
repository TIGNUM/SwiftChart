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
        router.presentRelatedArticle(readMoreID: readMoreID)
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

    func updateStrategies(selectedIds: [Int]) {
       worker.updateStrategies(selectedIds: selectedIds)
    }

    func updateIntentions(_ answerIds: [Int]) {
        worker.updateIntentions(answerIds)
    }

    func updateBenefits(_ benefits: String) {
       worker.updateBenefits(benefits)
    }

    func presentFeedback() {
        router.presentFeedback()
    }

    func deletePreparation() {
        worker.deletePreparation()
    }

    func updatePreparation() {
        worker.updatePreparation { _ in }
    }

    func didClickSaveAndContinue() {
        updatePreparation()
    }
}
