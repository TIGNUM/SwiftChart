//
//  TeamEditRouter.swift
//  QOT
//
//  Created by karmic on 23.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TeamEditRouter {

    // MARK: - Properties
    private weak var viewController: TeamEditViewController?

    // MARK: - Init
    init(viewController: TeamEditViewController?) {
        self.viewController = viewController
    }
}

// MARK: - TeamEditRouterInterface
extension TeamEditRouter: TeamEditRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
