//
//  MySprintDetailsPresenter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MySprintDetailsPresenter {

    // MARK: - Properties
    private weak var viewController: MySprintDetailsViewControllerInterface?

    // MARK: - Init
    init(viewController: MySprintDetailsViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - MySprintDetailsInterface
extension MySprintDetailsPresenter: MySprintDetailsPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func present() {
        viewController?.update()
    }
    func trackSprintPause() {
        viewController?.trackSprintPause()
    }

    func trackSprintContinue() {
        viewController?.trackSprintContinue()
    }

    func trackSprintStart() {
        viewController?.trackSprintStart()
    }

    func presentAlert(title: String, message: String, buttons: [UIBarButtonItem]) {
        viewController?.presentAlert(title: title, message: message, buttons: buttons)
    }
}
