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
    private let delegate: OnboardingLoginDelegate

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
        delegate.didTapBack()
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
                self?.didTapSendCode(to: email)
                return
            } else if let error = error {
                qot_dal.log("Failed to verify email: \(error)", level: .debug)
                self?.viewModel.emailError = self?.worker.emailError
            } else if case .userDoesNotExist = result.code {
                self?.viewModel.emailError = self?.worker.emailUserDoesntExist
            } else {
                self?.viewModel.emailError = self?.worker.generalEMailError
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
                self?.presenter.presentCodeEntry()
                self?.viewModel.sendCodeEnabled = true
            } else if let error = error {
                qot_dal.log("Failed to request login code: \(error)", level: .debug)
                self?.viewModel.emailError = self?.worker.emailError
            } else {
                self?.viewModel.emailError = self?.worker.generalEMailError
            }
            self?.viewModel.sendCodeEnabled = true
            self?.presenter.present()
            self?.presenter.presentActivity(state: nil)
        }
    }

    func validateLoginCode(_ code: String, for email: String?, toBeVision: CachedToBeVision?) {
        guard checkAndPresentEmailVailidty(email) == true, let email = email else {
            return
        }

        presenter.presentActivity(state: .inProgress)
        worker.validate(code: code, for: email) { [weak self] (result, error) in
            self?.presenter.presentActivity(state: nil)
            switch result.code {
            case .codeValid,
                 .valid:
                // Update ToBeVision
                if let tbv = toBeVision {
//                    self?.worker.updateToBeVision(with: tbv) // FIXME: ZZ: Cache TBV
                }
                // Show main app
                self?.handleSuccessfulLogin()
                return
            default:
                break
            }

            // Unsuccessful code check
            self?.viewModel.codeError = self?.worker.codeError
            if let error = error {
                qot_dal.log("Error sending login code: \(error)", level: .debug)
            }
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

    func handleSuccessfulLogin() {
        if !UserDefault.didShowCoachMarks.boolValue {
            delegate.showTrackSelection()
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
