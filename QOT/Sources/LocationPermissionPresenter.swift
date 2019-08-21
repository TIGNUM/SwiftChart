//
//  LocationPermissionPresenter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 14/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class LocationPermissionPresenter {

    // MARK: - Properties

    private weak var viewController: LocationPermissionViewControllerInterface?

    // MARK: - Init

    init(viewController: LocationPermissionViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - LocationPermissionInterface

extension LocationPermissionPresenter: LocationPermissionPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func presentDeniedPermissionAlert() {
        viewController?.presentDeniedPermissionAlert()
    }
}
