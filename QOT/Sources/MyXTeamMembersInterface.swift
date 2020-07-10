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
}

protocol MyXTeamMembersRouterInterface {
    func dismiss()
}
