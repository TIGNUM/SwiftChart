//
//  ShifterResultInteractor.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 10.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class ShifterResultInteractor {

    // MARK: - Properties
    private let worker: ShifterResultWorker
    private let presenter: ShifterResultPresenterInterface
    private let router: ShifterResultRouterInterface

    // MARK: - Init
    init(worker: ShifterResultWorker,
        presenter: ShifterResultPresenterInterface,
        router: ShifterResultRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
        presenter.load(worker.getMindsetShifterResultModel())
    }
}

// MARK: - ShifterResultInteractorInterface
extension ShifterResultInteractor: ShifterResultInteractorInterface {
    func didTapSave() {
        router.dismiss()
    }

    func deleteModel() {
        worker.deleteMindsetShifter()
    }

    func didTapDismiss() {
        router.dismiss()
    }
}
