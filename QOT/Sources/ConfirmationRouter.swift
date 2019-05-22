//
//  ConfirmationRouter.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 09.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class ConfirmationRouter {

    // MARK: - Properties

    private let viewController: ConfirmationViewController

    // MARK: - Init

    init(viewController: ConfirmationViewController) {
        self.viewController = viewController
    }
}

// MARK: - ConfirmationRouterInterface

extension ConfirmationRouter: ConfirmationRouterInterface {

    func dismiss() {
        viewController.dismiss(animated: true, completion: nil)
    }
}
