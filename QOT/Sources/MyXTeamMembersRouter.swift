//
//  MyXTeamMembersRouter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class MyXTeamMembersRouter {

    // MARK: - Properties
    private weak var viewController: MyXTeamMembersViewController?

    // MARK: - Init
    init(viewController: MyXTeamMembersViewController?) {
        self.viewController = viewController
    }
}

// MARK: - MyXTeamMembersRouterInterface
extension MyXTeamMembersRouter: MyXTeamMembersRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
