//
//  ProfileSettingsRouter.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 23/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class ProfileSettingsRouter {

    private weak var viewController: ProfileSettingsViewController?

    init(settingsMenuViewController: ProfileSettingsViewController) {
        self.viewController = settingsMenuViewController
    }
}

extension ProfileSettingsRouter: ProfileSettingsRouterInterface { }
