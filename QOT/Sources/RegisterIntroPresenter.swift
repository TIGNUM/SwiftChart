//
//  RegisterIntroPresenter.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 05/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegisterIntroPresenter {

    // MARK: - Properties
    private weak var viewController: RegisterIntroViewControllerInterface?

    // MARK: - Init
    init(viewController: RegisterIntroViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - RegisterIntroInterface
extension RegisterIntroPresenter: RegisterIntroPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}
