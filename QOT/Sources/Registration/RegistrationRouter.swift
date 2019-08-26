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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.appCoordinator.showApp()
    }
}
