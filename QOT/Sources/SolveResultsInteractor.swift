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
    private let presenter: SolveResultsPresenterInterface
    private let router: SolveResultsRouterInterface

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
        presenter.present(worker.results)
    }
}

// MARK: - SolveResultsInteractorInterface

extension SolveResultsInteractor: SolveResultsInteractorInterface {
    var hideShowMoreButton: Bool {
        return worker.hideShowMoreButton
    }

    func save() {
        worker.save(completion: {
            router.dismiss()
        })
    }

    func didTapStrategy(with id: Int) {
        router.openStrategy(with: id)
    }

    func didTapTrigger(_ type: SolveTriggerType) {
        switch type {
        case .midsetShifter: router.openMindsetShifter()
        case .tbvGenerator: router.openVisionGenerator()
        }
    }

    func openConfirmationView() {
        router.openConfirmationView()
    }
}
