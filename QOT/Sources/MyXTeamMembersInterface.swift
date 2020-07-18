//
//  MyXTeamMembersInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol MyXTeamMembersViewControllerInterface: class {
    func setupView()
    func updateTeamHeader(teamHeaderItems: [Team.Item])
    func updateView()
}

protocol MyXTeamMembersPresenterInterface {
    func setupView()
    func updateTeamHeader(teamHeaderItems: [Team.Item])
    func updateView()
}

protocol MyXTeamMembersInteractorInterface: Interactor {
    var rowCount: Int { get }
    var teamMembersText: String { get }
    var selectedTeam: QDMTeam? { get }

    func removeMember(at indexPath: IndexPath)
    func reinviteMember(at indexPath: IndexPath)
    func getMember(at indexPath: IndexPath) -> TeamMember?
}

protocol MyXTeamMembersRouterInterface {
    func dismiss()
}
