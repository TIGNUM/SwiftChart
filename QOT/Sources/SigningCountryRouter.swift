//
//  SigningCountryRouter.swift
//  QOT
//
//  Created by karmic on 07.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningCountryRouter {

    // MARK: - Properties

    private let viewController: SigningCountryViewController

    // MARK: - Init

    init(viewController: SigningCountryViewController) {
        self.viewController = viewController
    }
}

// MARK: - SigningCountryRouterInterface

extension SigningCountryRouter: SigningCountryRouterInterface {

    func showProfileDetailsView(userSigning: UserSigning) {
        let configurator = SigningProfileDetailConfigurator.make(userSigning: userSigning)
        let controller = SigningProfileDetailViewController(configure: configurator)
        AppDelegate.current.windowManager.show(controller, animated: true, completion: nil)
    }
}
