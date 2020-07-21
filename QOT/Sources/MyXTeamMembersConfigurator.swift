//
//  MyXTeamMembersConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyXTeamMembersConfigurator {
    static func make(team: QDMTeam?) -> (MyXTeamMembersViewController) -> Void {
        return { (viewController) in
            let presenter = MyXTeamMembersPresenter(viewController: viewController)
            let interactor = MyXTeamMembersInteractor(presenter: presenter, team: team)
            viewController.interactor = interactor
        }
    }
}
