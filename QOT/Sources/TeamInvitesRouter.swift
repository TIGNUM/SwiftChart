//
//  TeamInvitesRouter.swift
//  QOT
//
//  Created by karmic on 14.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class TeamInvitesRouter {

    // MARK: - Properties
    private weak var viewController: TeamInvitesViewController?

    // MARK: - Init
    init(viewController: TeamInvitesViewController?) {
        self.viewController = viewController
    }
}

// MARK: - TeamInvitesRouterInterface
extension TeamInvitesRouter: TeamInvitesRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
