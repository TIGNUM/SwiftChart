//
//  MyXTeamSettingsConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 29.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyXTeamSettingsConfigurator {
    static func configure(viewController: MyXTeamSettingsViewController) {
        let router = MyXTeamSettingsRouter(viewController: viewController)
        let presenter = MyXTeamSettingsPresenter(viewController: viewController)
        let interactor = MyXTeamSettingsInteractor(presenter: presenter)
        viewController.interactor = interactor
        viewController.router = router
    }
}
