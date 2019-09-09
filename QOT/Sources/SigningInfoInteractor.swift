//
//  SigningInfoInteractor.swift
//  QOT
//
//  Created by karmic on 28.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningInfoInteractor {

    // MARK: - Properties

    private let worker: SigningInfoWorker
    private let presenter: SigningInfoPresenterInterface
    private let router: SigningInfoRouterInterface
    private let delegate: SigningInfoDelegate

    // MARK: - Init

    init(worker: SigningInfoWorker,
        presenter: SigningInfoPresenterInterface,
        router: SigningInfoRouterInterface,
        delegate: SigningInfoDelegate) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
        self.delegate = delegate
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setup()
    }
}

// MARK: - SigningInfoInteractorInterface

extension SigningInfoInteractor: SigningInfoInteractorInterface {

    func title(at item: Int) -> String? {
        return worker.title(at: item)
    }

    func body(at item: Int) -> String? {
        return worker.body(at: item)
    }

    func didTapLoginButton() {
        delegate.didTapLogin()
    }

    func didTapStartButton() {
        delegate.didTapStart()
    }
}
