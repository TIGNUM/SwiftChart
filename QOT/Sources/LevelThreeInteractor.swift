//
//  LevelThreeInteractor.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class LevelThreeInteractor {

    // MARK: - Properties

    private let worker: LevelThreeWorker
    private let presenter: LevelThreePresenterInterface
    private let router: LevelThreeRouterInterface

    // MARK: - Init

    init(worker: LevelThreeWorker,
        presenter: LevelThreePresenterInterface,
        router: LevelThreeRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {

    }
}

// MARK: - LevelThreeInteractorInterface

extension LevelThreeInteractor: LevelThreeInteractorInterface {

}
