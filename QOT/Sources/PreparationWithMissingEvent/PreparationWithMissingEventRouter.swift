//
//  PreparationWithMissingEventRouter.swift
//  QOT
//
//  Created by Sanggeon Park on 18.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class PreparationWithMissingEventRouter {

    // MARK: - Properties

    private weak var viewController: PreparationWithMissingEventViewController?

    // MARK: - Init

    init(viewController: PreparationWithMissingEventViewController) {
        self.viewController = viewController
    }
}

// MARK: - PreparationWithMissingEventRouterInterface

extension PreparationWithMissingEventRouter: PreparationWithMissingEventRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
