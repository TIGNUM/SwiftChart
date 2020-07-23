//
//  TeamInvitesPresenter.swift
//  QOT
//
//  Created by karmic on 14.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class TeamInvitesPresenter {

    // MARK: - Properties
    private weak var viewController: TeamInvitesViewControllerInterface?

    // MARK: - Init
    init(viewController: TeamInvitesViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - TeamInvitesInterface
extension TeamInvitesPresenter: TeamInvitesPresenterInterface {
    func reload(shouldDismiss: Bool) {
        viewController?.reload(shouldDismiss: shouldDismiss)
    }

    func setupView() {
        viewController?.setupView()
    }
}
