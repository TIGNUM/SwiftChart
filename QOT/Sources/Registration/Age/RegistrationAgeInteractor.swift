//
//  RegistrationAgeInteractor.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 14/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegistrationAgeInteractor {

    // MARK: - Properties

    private let worker: RegistrationAgeWorker
    private let presenter: RegistrationAgePresenterInterface
    private let router: RegistrationAgeRouterInterface
    private let delegate: RegistrationDelegate

    // MARK: - Init

    init(worker: RegistrationAgeWorker,
        presenter: RegistrationAgePresenterInterface,
        router: RegistrationAgeRouterInterface,
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

    var descriptionText: String {
        return worker.descriptionText
    }

    var ageRestrictionText: String {
        return worker.ageRestrictionText
    }

    var createButtonTitle: String {
        return worker.nextButtonTitle
    }
}

// MARK: - RegistrationAgeInteractorInterface

extension RegistrationAgeInteractor: RegistrationAgeInteractorInterface {
    func didTapBack() {
        delegate.didTapBack()
    }

    func didTapNext(with birthYear: String) {
        delegate.didTapCreateAccount(with: birthYear)
    }
}
