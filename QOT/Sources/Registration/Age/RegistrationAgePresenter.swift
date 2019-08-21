//
//  RegistrationAgePresenter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 14/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegistrationAgePresenter {

    // MARK: - Properties

    private weak var viewController: RegistrationAgeViewControllerInterface?

    // MARK: - Init

    init(viewController: RegistrationAgeViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - RegistrationAgeInterface

extension RegistrationAgePresenter: RegistrationAgePresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}
