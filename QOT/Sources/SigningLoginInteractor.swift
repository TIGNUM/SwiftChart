//
//  SigningLoginInteractor.swift
//  QOT
//
//  Created by karmic on 05.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit
import SVProgressHUD

final class SigningLoginInteractor {

    // MARK: - Properties

    private let worker: SigningLoginWorker
    private let presenter: SigningLoginPresenterInterface
    private let router: SigningLoginRouterInterface

    // MARK: - Init

    init(worker: SigningLoginWorker,
        presenter: SigningLoginPresenterInterface,
        router: SigningLoginRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setup()
    }
}

// MARK: - SigningLoginInteractorInterface

extension SigningLoginInteractor: SigningLoginInteractorInterface {

    func didTapbedForgettPasswordButton() {
        let email = worker.email
        SVProgressHUD.show()
        worker.sendResetPassword { [weak self] (error) in
            SVProgressHUD.dismiss()
            if let error = error {
                self?.router.handleResetPasswordError(error)
            } else {
                let fullMessage = R.string.localized.signingLoginHudTitlePasswordReset() + "\n" +
                    R.string.localized.signingLoginHudMessagePasswordReset(email)
                SVProgressHUD.showSuccess(withStatus: fullMessage)
                self?.presenter.didResendPassword()
            }
        }
    }

    func updateWorkerValue(for formType: FormView.FormType?) {
        guard let formType = formType else { return }
        switch formType {
        case .password(let value): updatePassword(value)
        default: return
        }
    }

    func updatePassword(_ password: String) {
        worker.password = password
        activateButton()
    }

	func didTapNext() {
        // FIXME: THIS VIEW CONTROLLER IS NOT USED
	}

    func activateButton() {
        let active = worker.email.isEmail == true && worker.password.count > 3
        presenter.activateButton(active)
    }

    var email: String {
        return worker.email
    }
}
