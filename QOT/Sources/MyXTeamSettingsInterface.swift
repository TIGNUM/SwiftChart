//
//  MyXTeamSettingsInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 29.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

protocol MyXTeamSettingsViewControllerInterface: class {
    func setup(_ settings: MyXTeamSettingsModel)
}

protocol MyXTeamSettingsPresenterInterface {
    func present(_ settings: MyXTeamSettingsModel)
}

protocol MyXTeamSettingsInteractorInterface: Interactor {
    func handleTap(setting:MyXTeamSettingsModel.Setting)
    var teamSettingsText: String { get }
}

protocol MyXTeamSettingsRouterInterface {
    func dismiss()
}
