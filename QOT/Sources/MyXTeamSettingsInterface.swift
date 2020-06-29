//
//  MyXTeamSettingsInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 29.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

protocol MyXTeamSettingsViewControllerInterface: class {
    func setupView()
}

protocol MyXTeamSettingsPresenterInterface {
    func setupView()
}

protocol MyXTeamSettingsInteractorInterface: Interactor {}

protocol MyXTeamSettingsRouterInterface {
    func dismiss()
}
