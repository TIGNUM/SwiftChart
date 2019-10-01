//
//  OnboardingLoginInteractor.swift
//  QOT
//
//  Created by karmic on 29.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class OnboardingLoginInteractor {

    // MARK: - Properties

    private let worker: OnboardingLoginWorker
    private let presenter: OnboardingLoginPresenterInterface
    private let router: OnboardingLoginRouterInterface
    private weak var delegate: OnboardingLoginDelegate?

    var viewModel = OnboardingLoginViewModel()

    // MARK: - Init

    init(worker: OnboardingLoginWorker,
        presenter: OnboardingLoginPresenterInterface,
        router: OnboardingLoginRouterInterface,
        delegate: OnboardingLoginDelegate) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
        self.delegate = delegate
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - OnoardingLoginInteractorInterface

extension OnboardingLoginInteractor: OnboardingLoginInteractorInterface {

    var title: String {
        return worker.title
    }

    var emailPlaceholder: String {
        return worker.emailPlaceholder
    }

    var emailInstructions: String {
        return worker.emailInstructions
    }

    var preCode: String {
        return worker.preCode
    }

    var digitDescription: String {
        return worker.digitDescription
    }

    var buttonGetHelp: String {
        return worker.buttonGetHelp
    }

    var buttonResendCode: String {
        return worker.buttonResendCode
    }

    func didTapBack() {
        delegate?.didTapBack()
    }

    func didTapVerify(email: String?) {
        guard checkAndPresentEmailVailidty(email) == true, let email = email else {
            return
        }
        viewModel.sendCodeEnabled = false
        presenter.present()
        presenter.presentActivity(state: .inProgress)
        worker.verifyEmail(email) { [weak self] (result, error) in
            if case .userExists = result.code {
                // Success
                self?.didTapSendCode(to: email)
                return
            } else if case .allowedToRegister = result.code {
                self?.viewModel.emailError = self?.worker.emailUserDoesntExist
            } else {
                self?.viewModel.emailError = result.message ?? self?.worker.generalEMailError
            }
            self?.viewModel.sendCodeEnabled = true
            self?.presenter.present()
            self?.presenter.presentActivity(state: nil)
        }
    }

    func didTapSendCode(to email: String?) {
        guard checkAndPresentEmailVailidty(email) == true, let email = email else {
            return
        }
        viewModel.sendCodeEnabled = false
        presenter.present()
        presenter.presentActivity(state: .inProgress)
        worker.requestCode(for: email) { [weak self] (result, error) in
            if case .codeSent = result.code {
                // Success
                self?.presenter.presentCodeEntry()
                self?.viewModel.sendCodeEnabled = true
            } else {
                self?.viewModel.emailError = result.message ?? self?.worker.generalEMailError
            }
            self?.viewModel.sendCodeEnabled = true
            self?.presenter.present()
            self?.presenter.presentActivity(state: nil)
        }
    }

    func validateLoginCode(_ code: String, for email: String?, toBeVision: QDMToBeVision?) {
        guard checkAndPresentEmailVailidty(email) == true, let email = email else {
            return
        }

        presenter.presentActivity(state: .inProgress)
        worker.validate(code: code, for: email, forLogin: true) { [weak self] (result, error) in
            self?.presenter.presentActivity(state: nil)
            switch result.code {
            case .codeValid,
                 .valid:
                // Update ToBeVision
                if let tbv = toBeVision {
                    self?.worker.updateToBeVision(with: tbv)
                }
                // Show main app
                self?.handleSuccessfulLogin(for: email)
                return
            default:
                break
            }

            // Unsuccessful code check
            self?.viewModel.codeError = result.message ?? self?.worker.codeError
            self?.presenter.present()
        }
    }

    func didTapGetHelpButton() {
        presenter.presentGetHelp()
    }

    func resetEmailError() {
        viewModel.emailError = nil
    }

    func resetCodeError() {
        viewModel.codeError = nil
    }
}

// MARK: - Private methods

private extension OnboardingLoginInteractor {

    func handleSuccessfulLogin(for email: String) {
        delegate?.didFinishLogin()

        let emails = UserDefault.didShowCoachMarks.object as? [String] ?? [String]()
        if !emails.contains(email) {
            delegate?.showTrackSelection()
        } else {
            router.showHomeScreen()
        }
    }

    func checkAndPresentEmailVailidty(_ email: String?) -> Bool {
        if worker.isValidEmail(email) == true {
            return true
        }

        viewModel.emailError = worker.emailError
        presenter.present()
        return false
    }
}
