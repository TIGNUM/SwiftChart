//
//  RegistrationNamesInteractor.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 12/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegistrationNamesInteractor {

    // MARK: - Properties

    private let worker: RegistrationNamesWorker
    private let presenter: RegistrationNamesPresenterInterface
    private let router: RegistrationNamesRouterInterface
    private weak var delegate: RegistrationDelegate?

    var hasFirstNameError: Bool = false
    var hasLastNameError: Bool = false

    // MARK: - Init

    init(worker: RegistrationNamesWorker,
        presenter: RegistrationNamesPresenterInterface,
        router: RegistrationNamesRouterInterface,
        delegate: RegistrationDelegate) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
        self.delegate = delegate
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setupView()
    }

    // MARK: - Texts

    var title: String {
        return worker.title
    }

    var firstNameTitle: String {
        return worker.firstNameTitle
    }

    var lastNameTitle: String {
        return worker.lastNameTitle
    }

    var mandatoryText: String {
        return worker.mandatoryText
    }

    var nextButtonTitle: String {
        return worker.nextButtonTitle
    }
}

// MARK: - RegistrationNamesInteractorInterface

extension RegistrationNamesInteractor: RegistrationNamesInteractorInterface {

    func didTapBack() {
        delegate?.didTapBack()
    }

    func didTapNext(with firstName: String, lastName: String?) {
        if !firstName.isValidName || firstName.isEmpty {
            hasFirstNameError = true
        }
        if let lastName = lastName, !lastName.isEmpty, !lastName.isValidName {
            hasLastNameError = true
        }
        if hasFirstNameError || hasLastNameError {
            presenter.presentView()
            return
        }
        delegate?.didSave(firstName: firstName, lastName: lastName)
    }

    func resetErrors() {
        hasFirstNameError = false
        hasLastNameError = false
        presenter.presentView()
    }
}
