//
//  ProfileSettingsPresenter.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 23/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class ProfileSettingsPresenter {

    private weak var viewController: ProfileSettingsViewControllerInterface?

    init(viewController: ProfileSettingsViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - SettingsMenuPresenter Interface

extension ProfileSettingsPresenter: ProfileSettingsPresenterInterface {

    func loadSettingsMenu(_ profile: ProfileSettingsModel) {
        viewController?.setup(profile: profile)
    }

    func updateSettingsMenu(_ profile: ProfileSettingsModel) {
        viewController?.update(profile: profile)
    }

    func presentImageError(_ error: Error) {
        viewController?.displayImageError()
    }
}
