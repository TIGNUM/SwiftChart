//
//  LevelTwoInteractor.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class LevelTwoInteractor {

    // MARK: - Properties

    private let worker: LevelTwoWorker
    private let presenter: LevelTwoPresenterInterface
    private let router: LevelTwoRouterInterface

    // MARK: - Init

    init(worker: LevelTwoWorker,
        presenter: LevelTwoPresenterInterface,
        router: LevelTwoRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - LevelTwoInteractorInterface

extension LevelTwoInteractor: LevelTwoInteractorInterface {
    func didTabCell(at: IndexPath) {
        router.didTabCell(at: at)
    }
}
