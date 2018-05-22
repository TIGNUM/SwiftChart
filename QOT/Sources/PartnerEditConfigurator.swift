//
//  PartnerEditConfigurator.swift
//  QOT
//
//  Created by karmic on 12.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation

final class PartnerEditConfigurator: AppStateAccess {

    static func make(partnerToEdit: Partners.Partner) -> (PartnerEditViewController) -> Void {
        return { (viewController) in
            let router = PartnerEditRouter(viewController: viewController,
                                           permissionManager: appState.permissionsManager)
            let worker = PartnerEditWorker(services: appState.services,
                                           syncManager: appState.syncManager,
                                           networkManager: appState.networkManager,
                                           partner: partnerToEdit)
            let presenter = PartnerEditPresenter(viewController: viewController)
            let interactor = PartnerEditInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
