//
//  RegistrationCodePresenter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 10/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegistrationCodePresenter {

    // MARK: - Properties
    private weak var viewController: RegistrationCodeViewControllerInterface?

    // MARK: - Init
    init(viewController: RegistrationCodeViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - RegistrationCodeInterface
extension RegistrationCodePresenter: RegistrationCodePresenterInterface {
    func setup() {
        viewController?.setupView()
    }

    func present() {
        viewController?.update()
    }

    func presentActivity(state: ActivityState?) {
        viewController?.trackUserEvent(.RESEND_CODE, action: .TAP)
        viewController?.presentActivity(state: state)
    }

    func presentGetHelp() {
        viewController?.presentGetHelpView()
    }
}
