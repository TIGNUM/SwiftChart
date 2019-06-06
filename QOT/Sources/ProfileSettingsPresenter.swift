//
//  ProfileSettingsPresenter.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 23/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class ProfileSettingsPresenter {

    private weak var viewController: ProfileSettingsViewControllerInterface?

    init(viewController: ProfileSettingsViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - SettingsMenuPresenter Interface

extension ProfileSettingsPresenter: ProfileSettingsPresenterInterface {
    func loadSettingsMenu(_ profile: QDMUser) {
        viewController?.setup(profile: profile)
    }
}
