//
//  MyXTeamSettingsRouter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 29.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

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
        viewController?.navigationController?.popViewController(animated: true)
    }

    func presentEditTeam(_ type: TeamEdit.View, team: QDMTeam?) {
        let identifier = R.storyboard.team.teamEditViewControllerID.identifier
        let controller = R.storyboard.team().instantiateViewController(withIdentifier: identifier) as? TeamEditViewController
        if let controller = controller {
            let configurator = TeamEditConfigurator.make(type: type, team: team)
            configurator(controller)
            viewController?.present(controller, animated: true)
        }
    }

    func presentTeamMembers() {
        let identifier = R.storyboard.myQot.myXTeamMembersViewController_ID.identifier
        let controller = R.storyboard.myQot().instantiateViewController(withIdentifier: identifier) as? MyXTeamMembersViewController
        if let controller = controller {
            let configurator = MyXTeamMembersConfigurator.make()
            configurator(controller)
            viewController?.show(controller, sender: nil)
        }
    }
}
