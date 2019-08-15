//
//  ConfirmationInteractor.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 09.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class ConfirmationInteractor {

    // MARK: - Properties
    private let worker: ConfirmationWorker
    private let presenter: ConfirmationPresenterInterface
    private let router: ConfirmationRouterInterface

    // MARK: - Init
    init(worker: ConfirmationWorker,
        presenter: ConfirmationPresenterInterface,
        router: ConfirmationRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
        worker.getModel { [unowned self] (model) in
            self.presenter.show(model)
        }
    }
}

// MARK: - ConfirmationInteractorInterface
extension ConfirmationInteractor: ConfirmationInteractorInterface {
    func didTapLeave() {
        router.leave()
    }

    func didTapDismiss() {
        router.dismiss()
    }
}
