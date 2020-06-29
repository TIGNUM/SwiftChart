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
    static func make() -> (MyXTeamSettingsViewController) -> Void {
        return { (viewController) in
            let router = MyXTeamSettingsRouter(viewController: viewController)
            let worker = MyXTeamSettingsWorker(contentService: qot_dal.ContentService.main)
            let presenter = MyXTeamSettingsPresenter(viewController: viewController)
            let interactor = MyXTeamSettingsInteractor(worker: worker, presenter: presenter)
            viewController.interactor = interactor
            viewController.router = router
        }
    }
}
