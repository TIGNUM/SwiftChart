//
//  MyXTeamMembersInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

protocol MyXTeamMembersViewControllerInterface: class {
    func setupView()
}

protocol MyXTeamMembersPresenterInterface {
    func setupView()
}

protocol MyXTeamMembersInteractorInterface: Interactor {}

protocol MyXTeamMembersRouterInterface {
    func dismiss()
}
