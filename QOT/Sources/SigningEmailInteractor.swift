//
//  SigningEmailInteractor.swift
//  QOT
//
//  Created by karmic on 29.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningEmailInteractor {

    // MARK: - Properties

    private let worker: SigningEmailWorker
    private let presenter: SigningEmailPresenterInterface
    private let router: SigningEmailRouterInterface
    private var formView: FormView?
    private let defaultError = "Please enter a valid email address"

    // MARK: - Init

    init(worker: SigningEmailWorker,
        presenter: SigningEmailPresenterInterface,
        router: SigningEmailRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setup()
    }
}

// MARK: - SigningEmailInteractorInterface

extension SigningEmailInteractor: SigningEmailInteractorInterface {

    func updateWorkerValue(for formType: FormView.FormType?) {
        guard let formType = formType else { return }
        switch formType {
        case .email(let value):
            worker.email = value.trimmed
            if worker.isEmail == true {
                presenter.hideErrorMessage()
                presenter.activateButton(true)
            }
        default: return
        }
    }

    func didTapNext() {
        if let email = worker.email, worker.isEmail == true {
            presenter.endEditing()
            worker.userEmailCheck { [weak self] (emailCheck: UserRegistrationCheck?) in
                self?.handleResponse(emailCheck: emailCheck, email: email)
            }
        } else {
            presenter.reload(errorMessage: defaultError, buttonActive: false)
        }
    }
}

// MARK: - Private

private extension SigningEmailInteractor {

    func handleResponse(emailCheck: UserRegistrationCheck?, email: String) {
        guard let emailCheck = emailCheck else {
            presenter.reload(errorMessage: defaultError, buttonActive: false)
            return
        }

        switch emailCheck.responseType {
        case .codeSent: router.openDigitVerificationView(email: email)
        case .userExist: router.openSignInView(email: email)
        case .invalid: presenter.reload(errorMessage: emailCheck.message, buttonActive: false)
        case .codeValid,
             .codeValidNoPassword,
             .userCreated: return
        }
    }
}
