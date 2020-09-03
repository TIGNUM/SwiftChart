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
    func reload(shouldDismiss: Bool)
    func showBanner(message: String)
}

protocol TeamInvitesPresenterInterface {
    func setupView()
    func reload(shouldDismiss: Bool)
    func showBanner(type: TeamInvite.BannerType)
}

protocol TeamInvitesInteractorInterface: Interactor {
    var sectionCount: Int { get }

    func rowCount(in section: Int) -> Int
    func section(at indexPath: IndexPath) -> TeamInvite.Section
    func pendingInvites(at indexPath: IndexPath) -> TeamInvite.Pending?
    func headerItem() -> (header: TeamInvite.Header?, teamCount: Int)
}

protocol TeamInvitesRouterInterface {
    func dismiss()
}
