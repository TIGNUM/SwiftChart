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
     func updateTeamHeader(teamHeaderItems: [TeamHeader])
     func updateView()
}

protocol MyXTeamMembersPresenterInterface {
    func setupView()
    func updateTeamHeader(teamHeaderItems: [TeamHeader])
    func updateView() 
}

protocol MyXTeamMembersInteractorInterface: Interactor {
    var teamMembersText: String { get }
    func removeMember(memberId: String?, team: QDMTeam)
    var selectedTeam: QDMTeam? { get }
    func reinviteMember(email: String?, team: QDMTeam?)
}

protocol MyXTeamMembersRouterInterface {
    func dismiss()
}
