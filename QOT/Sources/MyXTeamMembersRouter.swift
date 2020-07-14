//
//  MyXTeamMembersRouter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

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

    func addMembers(team: QDMTeam?) {
        let identifier = R.storyboard.team.teamEditViewControllerID.identifier
        let controller = R.storyboard.team().instantiateViewController(withIdentifier: identifier) as? TeamEditViewController
        if let controller = controller {
            let configurator = TeamEditConfigurator.make(type: .memberInvite, team: team)
            configurator(controller)
            viewController?.present(controller, animated: true)
        }
    }
}
