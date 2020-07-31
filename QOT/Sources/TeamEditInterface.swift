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
    func setupView(_ type: TeamEdit.View, _ teamName: String?)
    func refreshView(_ type: TeamEdit.View)
    func setupLabels(header: String, subHeader: String, description: String, cta: String, animated: Bool)
    func updateTextCounter(type: TeamEdit.View, max: Int)
    func presentErrorAlert(_ title: String, _ message: String)
    func refreshMemberList(at indexPath: [IndexPath])
    func dismiss()
}

protocol TeamEditPresenterInterface {
    func setupView(_ type: TeamEdit.View, teamName: String?)
    func setupTextCounter(type: TeamEdit.View, max: Int)
    func prepareMemberInvite(_ teamName: String?, maxMemberCount: Int)
    func refreshMemberList(at indexPath: [IndexPath])
    func presentErrorAlert(_ title: String, _ message: String)
}

protocol TeamEditInteractorInterface: Interactor {
    var getType: TeamEdit.View { get }
    var sectionCount: Int { get }
    var maxMemberCount: Int { get }
    var canSendInvite: Bool { get }

    func rowCount(in section: Int) -> Int
    func item(at index: IndexPath) -> String?
    func createTeam(_ name: String?)
    func sendInvite(_ email: String?)
    func getMaxChars(_ completion: @escaping (Int) -> Void)
    func updateTeamName(_ name: String?)
}

protocol TeamEditRouterInterface {
    func dismiss()
}
