//
//  SolveResultsInteractor.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 03.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class SolveResultsInteractor {

    // MARK: - Properties
    private let worker: SolveResultsWorker
    private let presenter: SolveResultsPresenterInterface?
    private let router: SolveResultsRouterInterface?

    // MARK: - Init
    init(worker: SolveResultsWorker,
         presenter: SolveResultsPresenterInterface,
         router: SolveResultsRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter?.setupView()
        presenter?.setupRightBottomNavigationBarItems(showSaveButton: worker.showSaveButton)
        worker.results { [weak self] (solveResults) in
            self?.presenter?.present(solveResults)
        }
    }
}

// MARK: - SolveResultsInteractorInterface
extension SolveResultsInteractor: SolveResultsInteractorInterface {
    var hideShowMoreButton: Bool {
        return worker.hideShowMoreButton
    }

    var resultType: ResultType {
        return worker.resultType
    }

    func save() {
        worker.save {}
    }

    func didTapStrategy(with id: Int) {
        router?.openStrategy(with: id)
    }

    func didTapTrigger(_ type: SolveTriggerType) {
        switch type {
        case .midsetShifter:
            router?.openMindsetShifter()
        case .tbvGenerator:
            router?.openRecovery()
        case .recoveryPlaner:
            router?.openRecovery()
        }
    }

    func deleteModel() {
        worker.deleteModel()
    }

    func dismiss() {
        router?.dismiss()
    }

    func didTapDone() {
        router?.didTapDone()
    }

    func isPresentingExistingSolve() -> Bool {
        return worker.hasExistingSolve()
    }

    func presentFeedback() {
        router?.presentFeedback()
    }
}
