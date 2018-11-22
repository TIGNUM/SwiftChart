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
        presenter.setup(code: worker.code)
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
        if code.isEmpty == true || code.count < 4 {
            presenter.reload(errorMessage: R.string.localized.signingDigitCheckError(), buttonActive: false)
        } else {
            worker.verify(code: code) { [weak self] (check: UserRegistrationCheck?) in
                self?.handleResponse(check: check)
            }
        }
    }
}

// MARK: - Private

private extension SigningDigitInteractor {

    func handleResponse(check: UserRegistrationCheck?) {
        guard var check = check else {
            presenter.reload(errorMessage: R.string.localized.signingDigitCheckError(), buttonActive: false)
            return
        }

        switch check.responseType {
        case .invalid: presenter.reload(errorMessage: check.message, buttonActive: false)
        case .codeValid,
             .codeValidNoPassword:
            check.userSigning?.verificationCode = worker.code
            let userSigning = check.userSigning ?? UserSigning(email: worker.email, code: worker.code)
            router.openCreatePasswordView(userSigning: userSigning, responseType: check.responseType)
        default: return // Do nothing
        }
    }
}
