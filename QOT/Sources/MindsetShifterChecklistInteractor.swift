//
//  MindsetShifterChecklistInteractor.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 10.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MindsetShifterChecklistInteractor {

    // MARK: - Properties

    private let worker: MindsetShifterChecklistWorker
    private let presenter: MindsetShifterChecklistPresenterInterface
    private let router: MindsetShifterChecklistRouterInterface

    // MARK: - Init

    init(worker: MindsetShifterChecklistWorker,
        presenter: MindsetShifterChecklistPresenterInterface,
        router: MindsetShifterChecklistRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.load(worker.model)
    }
}

// MARK: - MindsetShifterChecklistInteractorInterface

extension MindsetShifterChecklistInteractor: MindsetShifterChecklistInteractorInterface {

    func didTapClose() {
        router.dismiss()
    }

    func didTapSave() {
    }
}
