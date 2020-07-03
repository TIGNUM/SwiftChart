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
    func presentErrorAlert(_ title: String, _ message: String)
    func refreshMemberList()
    func dismiss()
}

protocol TeamEditPresenterInterface {
    func setupView(_ type: TeamEdit.View)
    func setupTextCounter(maxChars: Int)
    func prepareMemberInvite(_ team: QDMTeam?)
    func refreshMemberList()
    func presentErrorAlert(_ error: Error?)
}

protocol TeamEditInteractorInterface: Interactor {
    var getType: TeamEdit.View { get }
    var rowCount: Int { get }
    var teamName: String? { get }
    func item(at index: IndexPath) -> String?
    func createTeam(_ name: String?)
    func sendInvite(_ email: String?)
    func getMaxChars(_ completion: @escaping (Int) -> Void)
}

protocol TeamEditRouterInterface {
    func dismiss()
}
