//
//  CoachInteractor.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class CoachInteractor {

    // MARK: - Properties

    private let worker: CoachWorker
    private let presenter: CoachPresenterInterface
    private let router: CoachRouterInterface

    // MARK: - Init

    init(worker: CoachWorker,
        presenter: CoachPresenterInterface,
        router: CoachRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - CoachInteractorInterface

extension CoachInteractor: CoachInteractorInterface {

}
