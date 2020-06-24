//
//  TeamEditInterface.swift
//  QOT
//
//  Created by karmic on 23.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol TeamEditViewControllerInterface: class {
    func setupView()
    func setupLabels(header: String, subHeader: String, description: String, cta: String)
    func showErrorAlert(_ error: Error?)
    func presentInviteView(team: QDMTeam?)
    func dismiss()
}

protocol TeamEditPresenterInterface {
    func setupView(_ type: TeamEdit.View)
    func handleResponseCreate(_ team: QDMTeam?, error: Error?)
    func handleResponseMemberInvite(_ member: QDMTeamMember?, error: Error?)
}

protocol TeamEditInteractorInterface: Interactor {
    var getType: TeamEdit.View { get }
    var getTeam: QDMTeam? { get }
    func createTeam(_ name: String)
    func sendInvite(_ email: String?, team: QDMTeam?)
}

protocol TeamEditRouterInterface {
    func dismiss()
    func presentInviteView(team: QDMTeam?)
}
