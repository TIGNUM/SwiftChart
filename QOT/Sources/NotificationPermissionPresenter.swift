//
//  NotificationPermissionPresenter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 14/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class NotificationPermissionPresenter {

    // MARK: - Properties

    private weak var viewController: NotificationPermissionViewControllerInterface?

    // MARK: - Init

    init(viewController: NotificationPermissionViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - LocationPermissionInterface

extension NotificationPermissionPresenter: NotificationPermissionPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func presentDeniedPermissionAlert() {
        viewController?.presentDeniedPermissionAlert()
    }
}
