//
//  RegistrationEmailPresenter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 08/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegistrationEmailPresenter {

    // MARK: - Properties

    private weak var viewController: RegistrationEmailViewControllerInterface?

    // MARK: - Init

    init(viewController: RegistrationEmailViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - RegistrationEmailInterface

extension RegistrationEmailPresenter: RegistrationEmailPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func present() {
        viewController?.updateView()
    }

    func presentActivity(state: ActivityState?) {
        viewController?.presentActivity(state: state)
    }
}
