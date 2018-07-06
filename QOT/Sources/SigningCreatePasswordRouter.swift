//
//  SigningCreatePasswordRouter.swift
//  QOT
//
//  Created by karmic on 07.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningCreatePasswordRouter {

    // MARK: - Properties

    private let viewController: SigningCreatePasswordViewController

    // MARK: - Init

    init(viewController: SigningCreatePasswordViewController) {
        self.viewController = viewController
    }
}

// MARK: - SigningCreatePasswordRouterInterface

extension SigningCreatePasswordRouter: SigningCreatePasswordRouterInterface {

    func showCountryView(userSigning: UserSigning) {
        let configurator = SigningCountryConfigurator.make(userSigning: userSigning)
        let controller = SigningCountryViewController(configure: configurator)
        AppDelegate.current.windowManager.show(controller, animated: true, completion: nil)
    }

    func showProfileDetailView(userSigning: UserSigning) {
        let configurator = SigningProfileDetailConfigurator.make(userSigning: userSigning)
        let controller = SigningProfileDetailViewController(configure: configurator)
        AppDelegate.current.windowManager.show(controller, animated: true, completion: nil)
    }
}
