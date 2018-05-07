//
//  SettingsPresenter.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 26/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class SettingsPresenter {

    private weak var viewController: SettingsViewControllerInterface?

    init(viewController: SettingsViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - SettingsPresenterInterface

extension SettingsPresenter: SettingsPresenterInterface {

    func present(_ settings: SettingsModel) {
        viewController?.setup(settings)
    }
}
