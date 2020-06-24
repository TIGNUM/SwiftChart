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
    func refreshView()
    func setupLabels(header: String, subHeader: String, description: String, cta: String, animated: Bool)
    func updateTextCounter(maxChars: Int?)
    func showErrorAlert(_ error: Error?)
    func didSendInvite(email: String)
    func dismiss()
}

protocol TeamEditPresenterInterface {
    func setupView(_ type: TeamEdit.View)
    func setupTextCounter(maxChars: Int)
    func handleResponseCreate(_ team: QDMTeam?, error: Error?)
    func handleResponseMemberInvite(_ member: QDMTeamMember?, error: Error?)
}

protocol TeamEditInteractorInterface: Interactor {
    var getType: TeamEdit.View { get }
    func createTeam(_ name: String?)
    func sendInvite(_ email: String?)
    func getMaxChars(_ completion: @escaping (Int) -> Void)
}

protocol TeamEditRouterInterface {
    func dismiss()
}
