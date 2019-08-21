//
//  RegistrationNamesPresenter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 12/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegistrationNamesPresenter {

    // MARK: - Properties

    private weak var viewController: RegistrationNamesViewControllerInterface?

    // MARK: - Init

    init(viewController: RegistrationNamesViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - RegistrationNamesInterface

extension RegistrationNamesPresenter: RegistrationNamesPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}
