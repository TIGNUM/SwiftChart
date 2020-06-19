//
//  CreateTeamRouter.swift
//  QOT
//
//  Created by karmic on 19.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class CreateTeamRouter {

    // MARK: - Properties
    private weak var viewController: CreateTeamViewController?

    // MARK: - Init
    init(viewController: CreateTeamViewController?) {
        self.viewController = viewController
    }
}

// MARK: - CreateTeamRouterInterface
extension CreateTeamRouter: CreateTeamRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
