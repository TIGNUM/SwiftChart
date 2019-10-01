//
//  SigningInfoInteractor.swift
//  QOT
//
//  Created by karmic on 28.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class SigningInfoInteractor {

    // MARK: - Properties

    private let worker: SigningInfoWorker
    private let presenter: SigningInfoPresenterInterface
    private let router: SigningInfoRouterInterface
    private weak var delegate: SigningInfoDelegate?

    // MARK: - Init

    init(worker: SigningInfoWorker,
        presenter: SigningInfoPresenterInterface,
        router: SigningInfoRouterInterface,
        delegate: SigningInfoDelegate?) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
        self.delegate = delegate
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setup()
        presentUnoptimizedAlertViewIfNeeded()
    }

    func presentUnoptimizedAlertViewIfNeeded() {
        if UIDevice.isPad || UIDevice.isSmallScreenDevice {
            let title = ScreenTitleService.main.localizedString(for: .OnboardingUnoptimizedDeviceAlertTitle)
            let message = ScreenTitleService.main.localizedString(for: .OnboardingUnoptimizedDeviceAlertMessage)
            let dismissButtonTitle = ScreenTitleService.main.localizedString(for: .OnboardingUnoptimizedDeviceButtonGotIt)
            presenter.presentUnoptimizedAlertView(title: title, message: message, dismissButtonTitle: dismissButtonTitle)
        }
    }
}

// MARK: - SigningInfoInteractorInterface

extension SigningInfoInteractor: SigningInfoInteractorInterface {

    var titleText: String? {
        return worker.titleText
    }

    var bodyText: String? {
        return worker.bodyText
    }

    func didTapLoginButton() {
        delegate?.didTapLogin()
    }

    func didTapStartButton() {
        delegate?.didTapStart()
    }
}
