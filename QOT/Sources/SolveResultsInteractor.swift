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

    // MARK: - Init
    init(worker: SolveResultsWorker, presenter: SolveResultsPresenterInterface) {
        self.worker = worker
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter?.setupView()
        worker.getResultViewModel { [weak self] (resultViewModel, isFollowUpActive) in
            self?.presenter?.present(resultViewModel, isFollowUpActive: isFollowUpActive)
        }
    }
}

// MARK: - SolveResultsInteractorInterface
extension SolveResultsInteractor: SolveResultsInteractorInterface {
    var hideShowMoreButton: Bool {
        return worker.hideShowMoreButton
    }

    var resultType: ResultType {
        return worker.type
    }

    func save(solveFollowUp: Bool) {
        worker.save(followUp: solveFollowUp) {}
    }

    func updateSolve(followUp: Bool) {
        worker.updateSolve(followUp: followUp)
    }
}
