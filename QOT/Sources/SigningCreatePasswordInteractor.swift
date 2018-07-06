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
        worker.userSigning?.password = formType.value
        updateViewState(active: worker.isPasswordSecure(password: worker.userSigning?.password) == true)
    }

    func didTapNext() {
        if worker.isPasswordSecure(password: worker.userSigning?.password) == true,
            let userSigning = worker.userSigning {
            if worker.responseType == .codeValid {
                updateViewState(active: true)
                router.showCountryView(userSigning: userSigning)
            } else if worker.responseType == .codeValidNoPassword {
                updateViewState(active: true)
                router.showProfileDetailView(userSigning: userSigning)
            }
        } else {
            presenter.reload(errorMessage: R.string.localized.signingPasswordError(), buttonActive: false)
        }
    }
}

// MARK: - Private

private extension SigningCreatePasswordInteractor {

    func updateViewState(active: Bool) {
        presenter.activateButton(active)
        if active == true {
            presenter.hideErrorMessage()
        }
    }
}
