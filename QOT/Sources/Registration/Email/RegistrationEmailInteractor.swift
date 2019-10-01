//
//  RegistrationEmailInteractor.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 08/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class RegistrationEmailInteractor {

    // MARK: - Properties

    private let worker: RegistrationEmailWorker
    private let presenter: RegistrationEmailPresenterInterface
    private let router: RegistrationEmailRouterInterface
    private weak var delegate: RegistrationDelegate?

    private var email: String?
    var isNextButtonEnabled: Bool = false
    var isDisplayingError: Bool = false
    var descriptionMessage: String?

    // MARK: - Init

    init(worker: RegistrationEmailWorker,
        presenter: RegistrationEmailPresenterInterface,
        router: RegistrationEmailRouterInterface,
        delegate: RegistrationDelegate) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
        self.delegate = delegate
    }

    // MARK: - Interactor

    var title: String {
        return worker.title
    }

    var emailPlaceholder: String {
        return worker.emailPlaceholder
    }

    var nextButtonTitle: String {
        return worker.nextButtonTitle
    }
}

// MARK: - RegistrationEmailInteractorInterface

extension RegistrationEmailInteractor: RegistrationEmailInteractorInterface {

    func viewDidLoad() {
        presenter.setupView()
    }

    func didTapBack() {
        delegate?.didTapBack()
    }

    func setEmail(_ email: String?) {
        checkEmailValidity(email)
    }

    func didTapNext() {
        guard let email = checkEmailValidity(self.email) else { return }

        presenter.presentActivity(state: .inProgress)
        worker.verifyEmail(email) { [weak self] (result, error) in
            guard let strongSelf = self else { return }
            // Existing account
            if case .userExists = result.code {
                strongSelf.delegate?.handleExistingUser(email: email)
                strongSelf.presenter.presentActivity(state: nil)
                return
            }
            // User isn't part of Tignum
            if case .unableToRegister = result.code {
                strongSelf.showMessage(text: result.message ?? strongSelf.worker.unableToRegisterError)
                strongSelf.presenter.presentActivity(state: nil)
                return
            }
            // Error
            if let error = error {
                qot_dal.log("Failed to get code before registration. Error \(error)")
                strongSelf.showMessage(text: result.message ?? strongSelf.worker.generalError, isError: true)
                strongSelf.presenter.presentActivity(state: nil)
                return
            }
            // Success
            strongSelf.requestCode(for: email)
        }
    }

    func resetError() {
        guard isDisplayingError else {
            return
        }
        isDisplayingError = false
        descriptionMessage = nil
        presenter.present()
    }
}

// MARK: - Private methods

private extension RegistrationEmailInteractor {
    @discardableResult func checkEmailValidity(_ email: String?) -> String? {
        if let email = email, worker.isValidEmail(email) {
            self.email = email
            isNextButtonEnabled = true
            presenter.present()
            return email
        }
        showMessage(text: worker.emailError)
        return nil
    }

    func showMessage(text: String, isError: Bool = false) {
        isNextButtonEnabled = false
        descriptionMessage = text
        isDisplayingError = isError
        presenter.present()
    }

    func requestCode(for email: String) {
        worker.requestCode(for: email) { [weak self] (result, error) in
            guard let strongSelf = self else { return }
            strongSelf.presenter.presentActivity(state: nil)
            // Success
            if case .codeSent = result.code {
                strongSelf.delegate?.didVerifyEmail(email)
                return
            }
            // Error
            if let error = error {
                qot_dal.log("Failed to get code before registration. Error \(error)")
            }
            strongSelf.showMessage(text: result.message ?? strongSelf.worker.generalError, isError: true)
        }
    }
}
