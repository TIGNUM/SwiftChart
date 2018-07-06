//
//  SigningProfileDetailInteractor.swift
//  QOT
//
//  Created by karmic on 12.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit
import MBProgressHUD

final class SigningProfileDetailInteractor {

    // MARK: - Properties

    private let worker: SigningProfileDetailWorker
    private let presenter: SigningProfileDetailPresenterInterface
    private let router: SigningProfileDetailRouterInterface

    // MARK: - Init

    init(worker: SigningProfileDetailWorker,
        presenter: SigningProfileDetailPresenterInterface,
        router: SigningProfileDetailRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setup()
    }
}

// MARK: - SigningProfileDetailInteractorInterface

extension SigningProfileDetailInteractor: SigningProfileDetailInteractorInterface {

    func showTermsOfUse() {
        router.showTermsOfUse()
    }

    func showPrivacyPolicy() {
        router.showPrivacyPolicy()
    }

    var code: String? {
        return worker.userSigning.verificationCode
    }

    var password: String? {
        return worker.userSigning.password
    }

    var country: UserCountry? {
        return worker.userSigning.country
    }

    var firstName: String? {
        return worker.userSigning.firstName
    }

    var lastName: String? {
        return worker.userSigning.lastName
    }

    var gender: String? {
        return worker.userSigning.gender
    }

    var dateOfBirth: String? {
        return worker.userSigning.birthdate
    }

    var email: String? {
        return worker.userSigning.email
    }

    func updateFirstName(_ firstName: String) {
        worker.userSigning.firstName = firstName
        activateButton()
    }

    func updateLastName(_ lastName: String) {
        worker.userSigning.lastName = lastName
        activateButton()
    }

    func updateGenderName(_ gender: String) {
        worker.userSigning.gender = gender
        activateButton()
    }

    func updateDateOfBirth(_ dateOfBirth: String) {
        worker.userSigning.birthdate = dateOfBirth
        activateButton()
    }

    func updateCheckBox(_ isChecked: Bool) {
        worker.checkBoxIsChecked = isChecked
        activateButton()
    }

    func didTapNext() {
        guard worker.activateButton() == true else { return }
        guard let window = AppDelegate.current.window else { return }
        let hud = MBProgressHUD.showAdded(to: window, animated: true, title: nil, message: nil)
        worker.createAccount { (userRegistrationCheck, error) in
            hud.hide(animated: true)
            self.handleResponse(registrationCheck: userRegistrationCheck, error: error)
        }
    }

    func activateButton() {
        presenter.activateButton(worker.activateButton())
    }

    func updateWorkerValue(for formType: FormView.FormType?) {
        guard let formType = formType else { return }
        switch formType {
        case .dateOfBirth(let text): updateDateOfBirth(text)
        case .firstName(let text): updateFirstName(text)
        case .gender(let text): updateGenderName(text)
        case .lastName(let text): updateLastName(text)
        default: return
        }
    }
}

// MARK: - Private

private extension SigningProfileDetailInteractor {

    func handleResponse(registrationCheck: UserRegistrationCheck?, error: Error?) {
        guard let registrationCheck = registrationCheck else {
            router.handleError(error)
            return
        }

        switch registrationCheck.responseType {
        case .userCreated: handleRegistrationSuccess(registrationCheck: registrationCheck)
        case .userExist: handleRegistrationFailure(registrationCheck: registrationCheck)
        case .invalid,
             .codeValid,
             .codeValidNoPassword,
             .codeSent: return
        }
    }

    func handleRegistrationSuccess(registrationCheck: UserRegistrationCheck) {
        if let window = AppDelegate.current.window {
            MBProgressHUD.showAdded(to: window,
                                    animated: true,
                                    title: R.string.localized.signingProfileHudTitleUserCreated(),
                                    message: registrationCheck.message
                ).hide(animated: true, afterDelay: 3)
        }
        LoginCoordinator.add3DTouchShortcuts()
        UserDefault.clearAllDataRegistration()
        AppDelegate.current.appCoordinator.didLogin()
    }

    func handleRegistrationFailure(registrationCheck: UserRegistrationCheck) {
        router.showAlert(message: registrationCheck.message)
    }
}
