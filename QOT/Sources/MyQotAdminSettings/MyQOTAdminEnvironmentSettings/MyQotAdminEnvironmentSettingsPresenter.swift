//
//  MyQotAdminEnvironmentSettingsPresenter.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotAdminEnvironmentSettingsPresenter {

    // MARK: - Properties
    private weak var viewController: MyQotAdminEnvironmentSettingsViewControllerInterface?

    // MARK: - Init
    init(viewController: MyQotAdminEnvironmentSettingsViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - MyQotAdminEnvironmentSettingsInterface
extension MyQotAdminEnvironmentSettingsPresenter: MyQotAdminEnvironmentSettingsPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}
