//
//  SigningDigitInteractor.swift
//  QOT
//
//  Created by karmic on 07.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningDigitInteractor {

    // MARK: - Properties

    private let worker: SigningDigitWorker
    private let presenter: SigningDigitPresenterInterface
    private let router: SigningDigitRouterInterface

    // MARK: - Init

    init(worker: SigningDigitWorker,
        presenter: SigningDigitPresenterInterface,
        router: SigningDigitRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setup()
    }
}

// MARK: - SigningDigitInteractorInterface

extension SigningDigitInteractor: SigningDigitInteractorInterface {

    func updateWorkerValue(for formType: FormView.FormType?) {
        // Do nothing
    }

    func didTapNext() {
        // Do nothing
    }

    var email: String {
        return worker.email
    }

    func resendCode() {
        router.openEnterEmailView()
    }

    func verify(code: String) {
        worker.verify(code: code) { [weak self] (check: UserRegistrationCheck?) in
            self?.handleResponse(check: check, email: self?.worker.email)
        }
    }
}

// MARK: - Private

private extension SigningDigitInteractor {

    func handleResponse(check: UserRegistrationCheck?, email: String?) {
        guard let check = check, let email = email else {
            presenter.reload(errorMessage: "Your verification code is invalid", buttonActive: false)
            return
        }

        switch check.responseType {
        case .invalid: presenter.reload(errorMessage: check.message, buttonActive: false)
        case .codeValid: router.openCreatePasswordView(email: email, code: worker.code)
        case .codeSent,
             .userExist,
             .userCreated: return // Do nothing
        }
    }
}
