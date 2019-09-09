//
//  DTSprintRouter.swift
//  QOT
//
//  Created by karmic on 07.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DTSprintRouter {

    // MARK: - Properties
    private weak var viewController: DTSprintViewController?

    // MARK: - Init
    init(viewController: DTSprintViewController?) {
        self.viewController = viewController
    }
}

// MARK: - DTSprintRouterInterface
extension DTSprintRouter: DTSprintRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
