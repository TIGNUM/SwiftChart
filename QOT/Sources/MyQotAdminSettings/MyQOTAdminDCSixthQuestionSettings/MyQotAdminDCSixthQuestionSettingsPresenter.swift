//
//  MyQotAdminDCSixthQuestionSettingsPresenter.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotAdminDCSixthQuestionSettingsPresenter {

    // MARK: - Properties
    private weak var viewController: MyQotAdminDCSixthQuestionSettingsViewControllerInterface?

    // MARK: - Init
    init(viewController: MyQotAdminDCSixthQuestionSettingsViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - MyQotAdminDCSixthQuestionSettingsInterface
extension MyQotAdminDCSixthQuestionSettingsPresenter: MyQotAdminDCSixthQuestionSettingsPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}
