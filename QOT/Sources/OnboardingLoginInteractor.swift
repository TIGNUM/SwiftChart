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
    private lazy var worker = OnboardingLoginWorker()
    private let presenter: OnboardingLoginPresenterInterface
    var viewModel = OnboardingLoginViewModel()

    // MARK: - Init
    init(presenter: OnboardingLoginPresenterInterface) {
        self.presenter = presenter
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

    var buttonChangeEmail: String {
        return worker.buttonChangeEmail
    }

    var buttonResendCode: String {
        return worker.buttonResendCode
    }

    var buttonSeparator: String {
        return worker.buttonSeparator
    }

    func didTapBack() {
        viewModel.sendCodeEnabled = true
    }

    func didTapVerify(email: String?, completion: @escaping () -> Void) {
        UserDefault.existingEmail.setStringValue(value: "")

        guard checkAndPresentEmailValidity(email) == true, let email = email else {
            return
        }
        viewModel.sendCodeEnabled = false
        presenter.present()
        presenter.presentActivity(state: .inProgress)
        worker.verifyEmail(email) { [weak self] (result, _) in
            guard let strongSelf = self else { return }

            strongSelf.viewModel.emailResponseCode = result.code
            switch result.code {
            case .userExists:    // Success
                strongSelf.didTapSendCode(to: email)
                return
            case .allowedToRegister:
                strongSelf.viewModel.emailError = nil
                strongSelf.didTapSendCode(to: email)
            case .userDoesNotExist:
                strongSelf.viewModel.emailError = strongSelf.worker.emailUserDoesntExist
            default:
                strongSelf.viewModel.emailError = result.message ?? strongSelf.worker.generalEMailError
            }
            strongSelf.viewModel.sendCodeEnabled = true
            if strongSelf.testForPreRegisteredUser() {
                UserDefault.existingEmail.setStringValue(value: email)
                strongSelf.presenter.presentReset()
                strongSelf.presenter.presentActivity(state: nil)
                completion()
            } else {
                strongSelf.presenter.present()
                strongSelf.presenter.presentActivity(state: nil)
            }
        }
    }

    func didTapSendCode(to email: String?) {
        guard checkAndPresentEmailValidity(email) == true, let email = email else {
            return
        }
        viewModel.sendCodeEnabled = false
        presenter.present()
        presenter.presentActivity(state: .inProgress)
        worker.requestCode(for: email) { [weak self] (result, _) in
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

    func validateLoginCode(_ code: String, for email: String?, completion: @escaping (Bool) -> Void) {
        guard checkAndPresentEmailValidity(email) == true, let email = email else {
            return
        }

        presenter.presentActivity(state: .inProgress)
        worker.validate(code: code, for: email, forLogin: true) { [weak self] (result, _) in
            self?.presenter.presentActivity(state: nil)
            switch result.code {
            case .codeValid,
                 .valid:
                // Show main app
                self?.handleSuccessfulLogin(for: email, completion: completion)
                return
            default:
                break
            }

            // Unsuccessful code check
            self?.viewModel.codeError = result.message ?? self?.worker.codeError
            self?.presenter.present()
        }
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
    func handleSuccessfulLogin(for email: String, completion: (Bool) -> Void) {
//        delegate?.didFinishLogin()
        let emails = UserDefault.didShowCoachMarks.object as? [String] ?? [String]()
        if !emails.contains(email) {
            completion(true)
        } else {
            completion(false)
        }
    }

    func checkAndPresentEmailValidity(_ email: String?) -> Bool {
        if worker.isValidEmail(email) == true {
            return true
        }

        viewModel.emailError = worker.emailError
        presenter.present()
        return false
    }

    func testForPreRegisteredUser() -> Bool {
        return viewModel.emailResponseCode == .allowedToRegister
    }
}
