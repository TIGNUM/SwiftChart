//
//  SigningCreatePasswordInteractor.swift
//  QOT
//
//  Created by karmic on 07.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningCreatePasswordInteractor {

    // MARK: - Properties

    private let worker: SigningCreatePasswordWorker
    private let presenter: SigningCreatePasswordPresenterInterface
    private let router: SigningCreatePasswordRouterInterface

    // MARK: - Init

    init(worker: SigningCreatePasswordWorker,
        presenter: SigningCreatePasswordPresenterInterface,
        router: SigningCreatePasswordRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setup()
    }
}

// MARK: - SigningCreatePasswordInteractorInterface

extension SigningCreatePasswordInteractor: SigningCreatePasswordInteractorInterface {

    func updateWorkerValue(for formType: FormView.FormType?) {
        guard let formType = formType else { return }
        worker.password = formType.value
        if worker.isPasswordSecure(password: worker.password ) == true {
            presenter.activateButton(true)
            presenter.hideErrorMessage()
        } else {
            presenter.activateButton(false)
        }
    }

    func didTapNext() {
        if worker.isPasswordSecure(password: worker.password) == true {
            presenter.activateButton(true)
            presenter.hideErrorMessage()
            router.showCountryView(email: worker.email, code: worker.code, password: worker.password)
        } else {
            presenter.reload(errorMessage: "Setting the password security level higher.", buttonActive: false)
        }
    }
}
