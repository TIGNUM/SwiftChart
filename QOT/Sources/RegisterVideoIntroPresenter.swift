//
//  RegisterVideoIntroPresenter.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 29/11/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegisterVideoIntroPresenter {

    // MARK: - Properties
    private weak var viewController: RegisterVideoIntroViewControllerInterface?

    // MARK: - Init
    init(viewController: RegisterVideoIntroViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - RegisterVideoIntroInterface
extension RegisterVideoIntroPresenter: RegisterVideoIntroPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}
