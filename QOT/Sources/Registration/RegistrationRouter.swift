//
//  RegistrationRouter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 08/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegistrationRouter {

    // MARK: - Properties

    private let viewController: RegistrationViewController

    // MARK: - Init

    init(viewController: RegistrationViewController) {
        self.viewController = viewController
    }
}

// MARK: - RegistrationRouterInterface

extension RegistrationRouter: RegistrationRouterInterface {
    func popBack() {
        viewController.navigationController?.popViewController(animated: true)
    }

    func showLocationPersmission(completion: (() -> Void)?) {
        let configurator = LocationPermissionConfigurator.make()
        guard let controller = R.storyboard.locationPermission.locationPermissionViewController() else { return }
        configurator(controller)
        viewController.present(controller, animated: true, completion: completion)
    }
}
