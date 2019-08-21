//
//  OnoardingLoginInteractor.swift
//  QOT
//
//  Created by karmic on 29.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class OnoardingLoginInteractor {

    // MARK: - Properties

    private let worker: OnoardingLoginWorker
    private let presenter: OnoardingLoginPresenterInterface
    private let router: OnoardingLoginRouterInterface

    // MARK: - Init

    init(worker: OnoardingLoginWorker,
        presenter: OnoardingLoginPresenterInterface,
        router: OnoardingLoginRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - OnoardingLoginInteractorInterface

extension OnoardingLoginInteractor: OnoardingLoginInteractorInterface {

}
