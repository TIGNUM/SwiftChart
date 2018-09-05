//
//  SigningLoginInteractor.swift
//  QOT
//
//  Created by karmic on 05.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit
import MBProgressHUD
import Appsee

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
        guard let window = AppDelegate.current.window else { return }
        let hud = MBProgressHUD.showAdded(to: window, animated: true)
        worker.sendResetPassword { [weak self] (error) in
            hud.hide(animated: true)
            if let error = error {
                self?.router.handleResetPasswordError(error)
            } else {
                MBProgressHUD.showAdded(to: window,
                                        animated: true,
                                        title: R.string.localized.signingLoginHudTitlePasswordReset(),
                                        message: R.string.localized.signingLoginHudMessagePasswordReset(email)
                    ).hide(animated: true, afterDelay: 3)
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
		guard let window = AppDelegate.current.window else { return }
		let hud = MBProgressHUD.showAdded(to: window, animated: true)
		worker.sendLoginRequest(email: worker.email,
								password: worker.password) { [weak self] (error) in
									hud.hide(animated: true)
									if let error = error {
										self?.router.handleLoginError(error)
									} else {
										LoginCoordinator.add3DTouchShortcuts()
										AppDelegate.current.appCoordinator.didLogin()
										self?.setAppseeUser()
									}
		}
	}

    func activateButton() {
        let active = worker.email.isEmail == true && worker.password.count > 3
        presenter.activateButton(active)
    }

	func setAppseeUser() {
		if let userID = worker.userIDForAppsee() {
			Appsee.setUserID(String(userID))
		}
	}

    var email: String {
        return worker.email
    }
}
