//
//  MyXTeamSettingsRouter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 29.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class MyXTeamSettingsRouter {

    // MARK: - Properties
    private weak var viewController: MyXTeamSettingsViewController?

    // MARK: - Init
    init(viewController: MyXTeamSettingsViewController?) {
        self.viewController = viewController
    }
}

// MARK: - MyXTeamSettingsRouterInterface
extension MyXTeamSettingsRouter: MyXTeamSettingsRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
