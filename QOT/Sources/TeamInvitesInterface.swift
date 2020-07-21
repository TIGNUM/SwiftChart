//
//  TeamInvitesInterface.swift
//  QOT
//
//  Created by karmic on 14.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol TeamInvitesViewControllerInterface: class {
    func setupView()
    func reload()
}

protocol TeamInvitesPresenterInterface {
    func setupView()
    func reload()
}

protocol TeamInvitesInteractorInterface: Interactor {
    var sectionCount: Int { get }
    func rowCount(in section: Int) -> Int
    func inviteItem(at row: Int) -> QDMTeamInvitation
    func headerItem() -> TeamInvite.Header?
}

protocol TeamInvitesRouterInterface {
    func dismiss()
}
