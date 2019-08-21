//
//  LocationPermissionRouter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 14/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class LocationPermissionRouter {

    // MARK: - Properties

    private let viewController: LocationPermissionViewController

    // MARK: - Init

    init(viewController: LocationPermissionViewController) {
        self.viewController = viewController
    }
}

// MARK: - LocationPermissionRouterInterface

extension LocationPermissionRouter: LocationPermissionRouterInterface {
    func dismiss() {
        viewController.didTapDismissButton()
    }

    func openSettings() {
        UIApplication.openAppSettings()
    }
}
