//
//  TeamInvitesInterface.swift
//  QOT
//
//  Created by karmic on 14.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

protocol TeamInvitesViewControllerInterface: class {
    func setupView()
}

protocol TeamInvitesPresenterInterface {
    func setupView()
}

protocol TeamInvitesInteractorInterface: Interactor {}

protocol TeamInvitesRouterInterface {
    func dismiss()
}
